# Priority Planner publishing instructions

The user requests that this app and all future versions be kept on GitHub.

- Keep sources/ in the parent project read-only.
- After implementing and verifying future app changes, commit and push them to this app's GitHub origin. This is standing user authorization; do not repeatedly ask whether to publish.
- For installable version updates, increment the Flutter version/build, build and validate the APK, then publish it with SHA256SUMS.txt and accurate release notes as GitHub release assets.
- Label development-signed builds as previews/prereleases. Preserve signing continuity; never commit keys, passwords, local.properties, personal planner data, backups, build output, or logs.
- Use a private repository by default when creating the initial repository unless the user specifies otherwise.
- If authentication is unavailable, prepare the local commit and explain the connection needed. Never claim a push or release succeeded without checking GitHub.
