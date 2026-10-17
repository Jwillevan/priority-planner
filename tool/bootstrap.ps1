# Run from the project root on Windows 11 after installing Flutter stable.
# This fills in SDK-generated wrapper artifacts without replacing app sources.
$ErrorActionPreference = "Stop"
$projectRoot = Split-Path -Parent $PSScriptRoot
Push-Location $projectRoot
try {
    if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) {
        throw "Install Flutter stable and add its bin directory to PATH first. See README.md."
    }
    flutter --version
    if ($LASTEXITCODE -ne 0) { throw "Flutter is not working." }

    $scaffold = Join-Path $projectRoot ".bootstrap\priority_planner"
    if (Test-Path $scaffold) { throw "Remove the previous .bootstrap directory before retrying." }
    flutter create --no-pub --platforms android --org com.priorityplanner --project-name priority_planner $scaffold
    if ($LASTEXITCODE -ne 0) { throw "Flutter scaffold creation failed." }

    # Keep reviewed Gradle versions and permissions. Copy only standard wrapper
    # scripts/JAR, not generated Kotlin, manifests, main.dart or Gradle config.
    foreach ($relative in @("gradlew", "gradlew.bat", "gradle\wrapper\gradle-wrapper.jar")) {
        $source = Join-Path "$scaffold\android" $relative
        if (-not (Test-Path $source)) { throw "Flutter did not generate $relative." }
        $destination = Join-Path "$projectRoot\android" $relative
        New-Item -ItemType Directory -Force (Split-Path -Parent $destination) | Out-Null
        Copy-Item $source $destination
    }

    flutter pub get
    if ($LASTEXITCODE -ne 0) { throw "Dependency resolution failed. See docs/DEPENDENCIES.md." }
    dart run build_runner build --delete-conflicting-outputs
    if ($LASTEXITCODE -ne 0) { throw "Drift generation failed." }
    Write-Host "Bootstrap complete. Run flutter analyze, flutter test, and flutter build apk --debug."
} finally {
    Pop-Location
}
