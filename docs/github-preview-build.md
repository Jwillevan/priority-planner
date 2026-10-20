# GitHub preview builds

The `Publish Android preview` workflow can build and publish 1.0.3 without locating
the original project folder or installing Flutter on the phone owner's computer.
It uses the pinned Flutter revision from the existing project, Java 21, Android
APIs 35 and 36, and NDK 28.2.13676358. It runs only when manually dispatched on `main`.
The Pub dependency cache lives beside the checkout, on the same Windows drive,
to avoid Kotlin incremental-compilation errors across drive roots.

## Signing key setup: once, on the computer that holds the existing key

The original 1.0.2 APK has certificate SHA-256:

`d17b5f5e009c8e7ec1d6fc00209eae3b60a2fac1f38beb8474ccf66e7c85049c`

Android requires that signing identity for an in-place update. A new development
key with the same alias/password is a different identity. The workflow verifies
the certificate before building and checks the built APK against the original
release again before publication. A missing/wrong key stops the job.

Check the usual Windows development-key location in PowerShell:

```powershell
Test-Path "$env:USERPROFILE\.android\debug.keystore"
```

If it exists, the owner can put it into an encrypted GitHub Actions repository
secret using their authenticated GitHub CLI. This sends the key to GitHub's
secret store; it does not commit it or display it. Do not paste the key or its
base64 representation into chat, source files, issues, or screenshots.

```powershell
Get-Command gh -ErrorAction Stop | Out-Null
$plannerKeyFile = Join-Path $env:USERPROFILE '.android\debug.keystore'
$plannerKeyData = [Convert]::ToBase64String([IO.File]::ReadAllBytes($plannerKeyFile))
try {
    $plannerKeyData | gh secret set ANDROID_DEBUG_KEYSTORE_BASE64 --repo Jwillevan/priority-planner
    if ($LASTEXITCODE -ne 0) { throw 'GitHub secret setup failed.' }
} finally {
    Remove-Variable plannerKeyData
}
```

File existence alone does not establish that the key matches. If the workflow
reports a certificate mismatch, the original signing key still needs to be
located. Do not uninstall the existing phone app to work around a mismatch.

## Build and publish

After configuring the matching key, use Actions > Publish Android preview > Run
workflow, or run:

```powershell
gh workflow run android-preview.yml --ref main --repo Jwillevan/priority-planner
```

The workflow runs the analyzer and unit/widget tests, builds the APK, verifies
the signer, app ID, version, label and uploaded checksums, then publishes a
prerelease with an APK and SHA256SUMS.txt. Signing files are removed at the end
and are not uploaded or cached. Runtime media, planner records and backups are
not inputs to this workflow.

The Windows hosted runner does not run the Android emulator integration test or
physical-phone acceptance checks. A workflow file or successful source commit
alone does not mean an APK release exists. Use the completed run and the actual
GitHub release assets as confirmation.
