# Run on the original Windows build computer to retain the installed APK's signer.
# No signing keys or tokens are read into script variables or written to Git.
param(
    [string]$AndroidTestDevice = '',
    [string]$AndroidSdkRoot = ''
)
$ErrorActionPreference = 'Stop'
$repository = 'Jwillevan/priority-planner'
$version = '1.0.3'
$buildNumber = 4
$tag = 'v1.0.3-preview.1'
$artifactName = 'Priority-Planner-1.0.3-preview.apk'
$referenceName = 'Priority-Planner-1.0.2-preview.apk'
$referenceHash = 'd742eba0731a11120a5b11f37d17d00160f65e129641c3c23491abacd245b8a4'
$projectPath = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$temporaryPath = Join-Path ([IO.Path]::GetTempPath()) ('planner-release-' + [guid]::NewGuid().ToString('N'))

function Invoke-Checked {
    param([string]$Command, [string[]]$Arguments)
    & $Command @Arguments
    if ($LASTEXITCODE -ne 0) { throw "$Command failed; no further publication steps will run." }
}

function Get-ApkSigner {
    param([string]$ApkPath)
    $output = & $script:apksigner verify --print-certs $ApkPath
    if ($LASTEXITCODE -ne 0) { throw 'APK signature verification failed.' }
    $certificateMatches = [regex]::Matches(($output -join "`n"), '(?m)^\s*Signer[^\r\n]*certificate SHA-256 digest:\s*([0-9a-fA-F]{64})\s*$')
    if ($certificateMatches.Count -eq 0) {
        # apksigner prints public APK certificate metadata, never private keys.
        Write-Host ($output -join "`n")
        throw 'APK signer could not be identified.'
    }
    return (($certificateMatches | ForEach-Object { $_.Groups[1].Value.ToLowerInvariant() } | Sort-Object -Unique) -join ',')
}

function Get-ApkPackage {
    param([string]$ApkPath)
    $output = & $script:aapt dump badging $ApkPath
    if ($LASTEXITCODE -ne 0) { throw 'APK metadata inspection failed.' }
    $text = $output -join "`n"
    $package = [regex]::Match($text, "package: name='([^']+)'.*versionCode='([0-9]+)'.*versionName='([^']+)'")
    if (-not $package.Success) { throw 'Missing APK package/version metadata.' }
    return [pscustomobject]@{
        Id = $package.Groups[1].Value
        Code = [int]$package.Groups[2].Value
        Version = $package.Groups[3].Value
        HasNewLabel = $text.Contains("application-label:'Top 9/Priority Planner'")
    }
}

Push-Location -LiteralPath $projectPath
try {
    foreach ($command in @('flutter', 'git', 'gh')) { Get-Command $command -ErrorAction Stop | Out-Null }
    Invoke-Checked 'gh' @('auth', 'status')
    $status = & git status --porcelain
    if ($LASTEXITCODE -ne 0 -or $status) { throw 'Use a clean Git checkout before building a release.' }
    $sourceSha = (& git rev-parse HEAD).Trim()
    if ($LASTEXITCODE -ne 0) { throw 'Cannot identify the source commit.' }
    $remoteSha = & gh api "repos/$repository/commits/$sourceSha" --jq '.sha'
    if ($LASTEXITCODE -ne 0 -or $remoteSha.Trim() -ne $sourceSha) { throw 'The source commit must already be on GitHub.' }
    $versionLine = Get-Content -LiteralPath 'pubspec.yaml' | Where-Object { $_ -match '^version:' }
    if ($versionLine -ne "version: $version+$buildNumber") { throw 'Expected source version 1.0.3+4.' }

    $candidates = @($AndroidSdkRoot, $env:ANDROID_HOME, $env:ANDROID_SDK_ROOT)
    if ($env:LOCALAPPDATA) { $candidates += (Join-Path $env:LOCALAPPDATA 'Android\Sdk') }
    $sdkPath = $candidates | Where-Object { $_ -and (Test-Path (Join-Path $_ 'build-tools')) } | Select-Object -First 1
    if (-not $sdkPath) { throw 'Android SDK not found. Pass -AndroidSdkRoot with the SDK path.' }
    # Use the version installed by the workflow, not unrelated prerelease tools
    # that may happen to be preinstalled on a hosted runner.
    $buildTools = Get-ChildItem -LiteralPath (Join-Path $sdkPath 'build-tools') -Directory |
        Where-Object { $_.Name -eq '36.0.0' } |
        Where-Object { (Test-Path (Join-Path $_.FullName 'apksigner.bat')) -and (Test-Path (Join-Path $_.FullName 'aapt.exe')) } |
        Sort-Object { [version]($_.Name -replace '-.*$', '') } -Descending | Select-Object -First 1
    if (-not $buildTools) { throw 'Install Android SDK Build-Tools with apksigner and aapt.' }
    $script:apksigner = Join-Path $buildTools.FullName 'apksigner.bat'
    $script:aapt = Join-Path $buildTools.FullName 'aapt.exe'

    New-Item -ItemType Directory -Path $temporaryPath | Out-Null
    Invoke-Checked 'gh' @('release', 'download', 'v1.0.2-preview.1', '--repo', $repository,
        '--pattern', $referenceName, '--dir', $temporaryPath)
    $referencePath = Join-Path $temporaryPath $referenceName
    if ((Get-FileHash -LiteralPath $referencePath -Algorithm SHA256).Hash.ToLowerInvariant() -ne $referenceHash) {
        throw 'The reference APK does not match the published 1.0.2 checksum.'
    }
    $oldSigner = Get-ApkSigner $referencePath
    $oldPackage = Get-ApkPackage $referencePath

    & (Join-Path $PSScriptRoot 'build-preview.ps1') -AndroidTestDevice $AndroidTestDevice
    $apkPath = Join-Path $projectPath "dist/$artifactName"
    $hashPath = Join-Path $projectPath 'dist/SHA256SUMS.txt'
    if (-not (Test-Path $apkPath)) { throw 'The build did not produce the 1.0.3 APK.' }
    if ((Get-ApkSigner $apkPath) -ne $oldSigner) {
        throw 'Signing mismatch. Restore the original 1.0.2 development key in the build environment. Nothing was uploaded; do not uninstall the phone app.'
    }
    $package = Get-ApkPackage $apkPath
    if ($package.Id -ne 'com.priorityplanner.priority_planner' -or $package.Id -ne $oldPackage.Id -or
        $package.Version -ne $version -or $package.Code -ne $buildNumber -or $package.Code -le $oldPackage.Code -or -not $package.HasNewLabel) {
        throw 'APK package ID, version, build number, or Top 9/ launcher label is incorrect.'
    }
    $changed = @(& git diff --name-only HEAD) | Where-Object { $_ -ne 'dist/SHA256SUMS.txt' }
    if ($LASTEXITCODE -ne 0 -or $changed) { throw 'Source files changed during the build. Review and commit them before publishing.' }
    $hash = (Get-FileHash -LiteralPath $apkPath -Algorithm SHA256).Hash.ToLowerInvariant()
    Set-Content -LiteralPath $hashPath -Encoding Ascii -Value "$hash  $artifactName"
    $notesPath = Join-Path $projectPath 'docs/release-1.0.3-preview.md'
    Invoke-Checked 'gh' @('release', 'create', $tag, $apkPath, $hashPath, '--repo', $repository,
        '--target', $sourceSha, '--title', 'Top 9/Priority Planner 1.0.3 preview',
        '--notes-file', $notesPath, '--draft', '--prerelease')

    # Verify the uploaded bytes before publishing the draft. A failure leaves a
    # draft for inspection, never an apparently available phone update.
    # GitHub does not expose an unpublished draft through the tag endpoint.
    # Find its unique ID in the authenticated release collection instead.
    $draftIds = @(& gh api --paginate "repos/$repository/releases?per_page=100" --jq ".[] | select(.tag_name == `"$tag`" and .draft) | .id")
    if ($LASTEXITCODE -ne 0 -or $draftIds.Count -ne 1) { throw 'Could not identify one matching draft release.' }
    $releaseJson = & gh api "repos/$repository/releases/$($draftIds[0])"
    if ($LASTEXITCODE -ne 0) { throw 'Could not verify the draft release.' }
    $release = ($releaseJson -join "`n") | ConvertFrom-Json
    $assets = @($release.assets | Where-Object { $_.name -eq $artifactName })
    $checksumAssets = @($release.assets | Where-Object { $_.name -eq 'SHA256SUMS.txt' })
    $checksumHash = (Get-FileHash -LiteralPath $hashPath -Algorithm SHA256).Hash.ToLowerInvariant()
    if (-not $release.draft -or -not $release.prerelease -or $release.tag_name -ne $tag -or $release.target_commitish -ne $sourceSha -or
        $assets.Count -ne 1 -or $assets[0].state -ne 'uploaded' -or $assets[0].digest -ne "sha256:$hash" -or
        $assets[0].size -ne (Get-Item -LiteralPath $apkPath).Length -or
        $checksumAssets.Count -ne 1 -or $checksumAssets[0].digest -ne "sha256:$checksumHash") {
        throw 'Draft asset verification failed. The release was not published.'
    }
    Invoke-Checked 'gh' @('api', '--method', 'PATCH', "repos/$repository/releases/$($release.id)",
        '-F', 'draft=false', '-F', 'prerelease=true', '-f', 'make_latest=false', '--silent')
    $publishedJson = & gh api "repos/$repository/releases/tags/$tag"
    if ($LASTEXITCODE -ne 0) { throw 'Publication response could not be checked. Inspect the GitHub release.' }
    $published = ($publishedJson -join "`n") | ConvertFrom-Json
    if ($published.draft -or -not $published.prerelease -or $published.tag_name -ne $tag -or
        $published.id -ne $release.id -or $published.target_commitish -ne $sourceSha) {
        throw 'GitHub did not confirm a published preview.'
    }
    Write-Output "Published and verified: $($published.html_url)"
} finally {
    if (Test-Path -LiteralPath $temporaryPath) { Remove-Item -LiteralPath $temporaryPath -Recurse -Force }
    Pop-Location
}
