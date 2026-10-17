param([string]$AndroidTestDevice = '')
$ErrorActionPreference = 'Stop'
$projectPath = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
Push-Location -LiteralPath $projectPath
try {
    & flutter pub get
    if ($LASTEXITCODE -ne 0) { throw 'Dependency resolution failed.' }
    & flutter analyze
    if ($LASTEXITCODE -ne 0) { throw 'Source analysis failed.' }
    & flutter test test
    if ($LASTEXITCODE -ne 0) { throw 'Unit/widget tests failed.' }
    if ($AndroidTestDevice) {
        & flutter test integration_test/android_test.dart -d $AndroidTestDevice
        if ($LASTEXITCODE -ne 0) { throw 'Android integration test failed.' }
    }
    # Keep Flutter commands sequential: pub/analyze/test can regenerate development plugin registration.
    & flutter build apk --release --config-only
    if ($LASTEXITCODE -ne 0) { throw 'Release configuration failed.' }
    & flutter build apk --release --no-pub
    if ($LASTEXITCODE -ne 0) { throw 'APK build failed.' }
    $versionLine = Get-Content -LiteralPath (Join-Path $projectPath 'pubspec.yaml') | Where-Object { $_ -match '^version:\s*(\d+\.\d+\.\d+)\+' } | Select-Object -First 1
    if ($versionLine -notmatch '^version:\s*(\d+\.\d+\.\d+)\+') { throw 'Missing app version.' }
    $artifactName = "Priority-Planner-$($Matches[1])-preview.apk"
    $artifactPath = Join-Path $projectPath "dist/$artifactName"
    New-Item -ItemType Directory -Force (Join-Path $projectPath 'dist') | Out-Null
    Copy-Item -LiteralPath (Join-Path $projectPath 'build/app/outputs/flutter-apk/app-release.apk') -Destination $artifactPath -Force
    $artifactHash = (Get-FileHash -LiteralPath $artifactPath -Algorithm SHA256).Hash.ToLowerInvariant()
    Set-Content -LiteralPath (Join-Path $projectPath 'dist/SHA256SUMS.txt') -Value "$artifactHash  $artifactName"
    Write-Output "Preview APK: $artifactPath"
    Write-Output 'This personal-test build uses the development signing key. Configure production signing before publication.'
} finally {
    Pop-Location
}
