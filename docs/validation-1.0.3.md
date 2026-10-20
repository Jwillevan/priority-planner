# 1.0.3 validation

Published source commit `a9d27f250b7cf95600ad6384ee1476e0e0da7384`:

- Flutter analyzer: no issues found.
- Unit and widget tests: all 34 passed.
- Release APK packaging: succeeded with Flutter 3.47.7 / Dart 3.13.5 and Java 21.
- APK metadata: `com.priorityplanner.priority_planner`, version `1.0.3`, build `4`.
- Android manifest label: `Top 9/Priority Planner`.
- GitHub workflow lint and publishing script PowerShell syntax checks: passed.

The Windows GitHub Actions run
[39499780655](https://github.com/Jwillevan/priority-planner/actions/runs/39499780655)
passed analysis and all 34 tests, built the release APK, verified signing
continuity, and uploaded both assets. Its final draft lookup failed because
unpublished drafts are unavailable through GitHub's release-by-tag endpoint.
Publication was completed by release ID after independently downloading and
verifying both uploaded assets. The helper now uses the release ID for drafts;
its syntax was checked, but the entire publishing workflow has not been rerun
after that helper-only fix.

[Published 1.0.3 preview](https://github.com/Jwillevan/priority-planner/releases/tag/v1.0.3-preview.1):

- APK size: 75,605,301 bytes.
- APK SHA-256: `e3d900ac4898b93abf743353bd535622ee8ba23c7eb7c842971539eb27385068`.
- Certificate SHA-256: `d17b5f5e009c8e7ec1d6fc00209eae3b60a2fac1f38beb8474ccf66e7c85049c`, matching 1.0.2.
- Uploaded checksum file and APK digests matched downloaded bytes.
- GitHub confirmed release ID `418906750` is published and marked as a prerelease.

An earlier Linux validation APK used a different temporary development key and
was never published. No signing keys or APK build outputs are committed. See
[GitHub preview builds](github-preview-build.md) for signing-key setup.

Physical-phone acceptance tests and Android emulator integration tests were not
run for this revision. Java source/target compatibility warnings occurred;
packaging completed successfully.
