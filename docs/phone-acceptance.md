# Priority Planner — Preview installation and phone checks

The final planned milestone produces an installable preview APK for personal acceptance testing. Emulator and automated checks do not replace testing on your own Android phone. This is not an app-store publication.

## Install

1. Copy `dist/Priority-Planner-1.0.0-preview.apk` to your Android phone (USB or your chosen file transfer).
2. Open the APK on the phone. If Android asks, allow this specific file source to install apps, then choose Install.
3. Open Priority Planner and choose Start Tutorial or Skip for Now. No account or subscription is required.
4. Try it with sample information first. Keep encrypted backups outside the app before entrusting irreplaceable records or uninstalling.

The APK is optimized and signed with the existing Android development key for personal testing. Production signing and app-store submission are separate decisions. Keep the signing identity consistent for future in-place updates; an incompatible signing key requires an uninstall, which removes application data. Back up first.

## Phone acceptance checklist

- [ ] Use the app offline. Create/edit ABC tasks, reorder, complete/delegate/cancel and review status history.
- [ ] Use Review unfinished tasks to forward a selected set; verify no duplicates and no false completions.
- [ ] Browse past/future dates. Rotate between portrait/landscape, try large text and TalkBack, and confirm page selection/readability.
- [ ] Create/edit overlapping and all-day appointments. Set schedule hours and check the current-time marker.
- [ ] Edit daily notes, wait for saved confirmation, restart the app, and confirm persistence.
- [ ] Create a formatted journal entry, change its date, add tags/category and related records; test search and date filters.
- [ ] Take/select photos, inspect thumbnails/full-screen view, add captions, reorder and remove an attachment.
- [ ] Import PDF/TXT/DOCX/XLSX files. Test opening with an installed compatible Android application. No internal preview for every file type is promised.
- [ ] Deny microphone permission once and retry after granting. Record, pause/resume, stop/save, rename, listen audibly and seek. Test a phone-call/background interruption.
- [ ] Define a role, values, goal and milestone; link a daily task and schedule a weekly/monthly master task.
- [ ] Preview and confirm recurring items; repeat the same preview to check duplicate prevention.
- [ ] Enable app lock with your device credential/biometrics, leave and return, and verify successful unlock and cancellation behavior.
- [ ] Enable notifications. Add a near-future task/appointment reminder and observe actual delivery, including with the screen off. Android battery restrictions/force stop may delay or suppress delivery; exact timing is not guaranteed.
- [ ] Export an encrypted backup and copy it off-device. Verify a wrong password is rejected. Restore only after exporting current records: restore replaces them and resets device lock/notification opt-ins.
- [ ] Verify low-storage and denied camera/gallery/document permissions produce useful failures without damaging saved records.

## Checks already run

- Source analysis and automated unit/widget tests (see milestone-8.md for final counts).
- Android 16 emulator installation/startup and native integration checks: SQLite reopen persistence; UI task creation; managed photo/document/audio copies; AAC recording with pause/resume/stop; native audio loading/seeking; local notification scheduling; backup encryption/validation.
- Portrait/spread/portrait selection retention, small-phone 2x text layout, lock accessibility masking and bulk review are covered by widget tests.

Not yet proven: real-phone biometric prompts, audible playback, actual notification delivery/reboot behavior, camera/gallery/file-provider interaction, TalkBack usability, real-call interruptions, low-storage behavior and broad device performance.
