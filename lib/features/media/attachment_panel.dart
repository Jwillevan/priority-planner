import 'recorder_port.dart';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:record/record.dart';
import 'package:just_audio/just_audio.dart';
import 'package:open_filex/open_filex.dart';
import 'package:uuid/uuid.dart';

import '../../data/database.dart';
import 'attachment_store.dart';

class AttachmentPanel extends StatefulWidget {
  const AttachmentPanel({
    required this.db,
    required this.entryId,
    required this.store,
    super.key,
  });
  final PlannerDatabase db;
  final int entryId;
  final AttachmentStore store;
  @override
  State<AttachmentPanel> createState() => _AttachmentPanelState();
}

class _AttachmentPanelState extends State<AttachmentPanel>
    with WidgetsBindingObserver {
  bool busy = false;
  String? message;
  Future<void> action(Future<void> Function() run) async {
    setState(() {
      busy = true;
      message = null;
    });
    try {
      await run();
    } catch (_) {
      if (mounted) {
        setState(
          () => message = 'Attachment action failed. Check permission, available storage, and the file, then retry.',
        );
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> photos(bool camera) async {
    final picker = ImagePicker();
    final items = camera
        ? [
            if (await picker.pickImage(source: ImageSource.camera)
                case final XFile photo)
              photo,
          ]
        : await picker.pickMultiImage();
    for (final item in items) {
      await widget.store.importFile(
        entryId: widget.entryId,
        source: File(item.path),
        name: item.name,
        kind: 'photo',
      );
    }
  }

  Future<void> documents() async {
    final result = await FilePicker.pickFiles();
    if (result.isEmpty) return;
    for (final item in result) {
      if (item.path == null) throw StateError('File unavailable');
      await widget.store.importFile(
        entryId: widget.entryId,
        source: File(item.path!),
        name: item.name,
        kind: 'document',
      );
    }
  }

  Future<void> edit(JournalAttachment a) async {
    final name = TextEditingController(text: a.displayName),
        caption = TextEditingController(text: a.caption);
    final yes = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Attachment details'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: name,
                decoration: const InputDecoration(labelText: 'Display name'),
              ),
              TextField(
                controller: caption,
                decoration: const InputDecoration(labelText: 'Caption'),
              ),
              Text('${a.bytes} bytes\nAdded ${a.createdAt.toLocal()}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Back'),
          ),
          TextButton(
            onPressed: () {
              if (name.text.trim().isNotEmpty) Navigator.pop(context, true);
            },
            child: const Text('Save details'),
          ),
        ],
      ),
    );
    if (yes == true) await widget.store.rename(a, name.text, caption.text);
    await Future<void>.delayed(const Duration(milliseconds: 300));
    name.dispose();
    caption.dispose();
  }

  Future<void> open(JournalAttachment a) async {
    final file = await widget.store.file(a.filename);
    if (!await file.exists()) throw StateError('Missing file');
    if (!mounted) return;
    if (a.kind == 'photo') {
      await Navigator.of(context).push<void>(
        MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(title: Text(a.displayName)),
            body: Center(
              child: InteractiveViewer(
                child: Image.file(
                  file,
                  errorBuilder: (_, error, stack) =>
                      const Text('Image cannot be decoded.'),
                ),
              ),
            ),
          ),
        ),
      );
    } else if (a.kind == 'audio') {
      await showDialog<void>(
        context: context,
        builder: (_) => AudioPlayback(file: file, title: a.displayName),
      );
    } else {
      final result = await OpenFilex.open(file.path);
      if (result.type != ResultType.done) throw StateError(result.message);
    }
  }

  @override
  Widget build(BuildContext context) => ExpansionTile(
    title: const Text('Photos, documents & voice'),
    children: [
      const Text(
        'Attachments save immediately, independently of journal text changes.',
      ),
      Wrap(
        children: [
          TextButton(
            onPressed: busy ? null : () => action(() => photos(true)),
            child: const Text('Take photo'),
          ),
          TextButton(
            onPressed: busy ? null : () => action(() => photos(false)),
            child: const Text('Choose photos'),
          ),
          TextButton(
            onPressed: busy ? null : () => action(documents),
            child: const Text('Attach files'),
          ),
          TextButton(
            onPressed: busy
                ? null
                : () => action(() async {
                    await showDialog<void>(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => VoiceRecorder(
                        store: widget.store,
                        entryId: widget.entryId,
                      ),
                    );
                  }),
            child: const Text('Record voice'),
          ),
        ],
      ),
      if (message != null) Text(message!),
      if (busy) const LinearProgressIndicator(),
      StreamBuilder<List<JournalAttachment>>(
        stream: widget.db.watchAttachments(widget.entryId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Attachments could not be loaded.');
          }
          final rows = snapshot.data ?? [];
          return Column(
            children: [
              for (var i = 0; i < rows.length; i++)
                Material(
                  type: MaterialType.transparency,
                  child: ListTile(
                    leading: rows[i].kind == 'photo'
                        ? FutureBuilder<File>(
                            future: widget.store.file(rows[i].filename),
                            builder: (context, file) => file.hasData
                                ? Image.file(
                                    file.data!,
                                    width: 48,
                                    height: 48,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, e, s) =>
                                        const Icon(Icons.broken_image),
                                  )
                                : const Icon(Icons.photo),
                          )
                        : Icon(
                            rows[i].kind == 'audio'
                                ? Icons.mic
                                : Icons.description_outlined,
                          ),
                    title: Text(rows[i].displayName),
                    subtitle: Text(
                      '${rows[i].kind} • ${rows[i].bytes} bytes\n${rows[i].caption}',
                    ),
                    onTap: busy ? null : () => action(() => open(rows[i])),
                    trailing: PopupMenuButton<String>(
                      enabled: !busy,
                      tooltip: 'Attachment actions',
                      onSelected: (choice) => action(() async {
                        if (choice == 'details') await edit(rows[i]);
                        if (choice == 'up') {
                          await widget.store.reorder(rows, i, i - 1);
                        }
                        if (choice == 'down') {
                          await widget.store.reorder(rows, i, i + 1);
                        }
                        if (choice == 'remove' && context.mounted) {
                          final yes = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Remove attachment?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Keep'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Remove'),
                                ),
                              ],
                            ),
                          );
                          if (yes == true) await widget.store.remove(rows[i]);
                        }
                      }),
                      itemBuilder: (_) => [
                        const PopupMenuItem(
                          value: 'details',
                          child: Text('Rename / caption / metadata'),
                        ),
                        if (i > 0)
                          const PopupMenuItem(
                            value: 'up',
                            child: Text('Move up'),
                          ),
                        if (i + 1 < rows.length)
                          const PopupMenuItem(
                            value: 'down',
                            child: Text('Move down'),
                          ),
                        const PopupMenuItem(
                          value: 'remove',
                          child: Text('Remove'),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    ],
  );
}

class VoiceRecorder extends StatefulWidget {
  const VoiceRecorder({
    required this.store,
    required this.entryId,
    this.backend,
    super.key,
  });
  final RecorderPort? backend;
  final AttachmentStore store;
  final int entryId;
  @override
  State<VoiceRecorder> createState() => _VoiceRecorderState();
}

class _VoiceRecorderState extends State<VoiceRecorder>
    with WidgetsBindingObserver {
  late final recorder = widget.backend ?? DeviceRecorder();
  String state = 'idle';
  String? error;
  File? draft;
  bool busy = false;
  final watch = Stopwatch();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed && this.state == 'recording') {
      run(() async {
        await recorder.pause();
        watch.stop();
        this.state = 'paused';
      });
    }
  }

  Future<void> run(Future<void> Function() f) async {
    setState(() {
      busy = true;
      error = null;
    });
    try {
      await f();
    } catch (_) {
      error =
          'Recording failed or microphone access was denied. Retry or discard.';
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> start() async {
    if (!await recorder.hasPermission()) throw StateError('Microphone denied');
    draft = await widget.store.file('${const Uuid().v4()}.m4a');
    await recorder.start(
      const RecordConfig(encoder: AudioEncoder.aacLc),
      path: draft!.path,
    );
    watch.reset();
    watch.start();
    state = 'recording';
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    watch.stop();
    recorder.dispose().then((_) async {
      if (draft != null && await draft!.exists()) await draft!.delete();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: false,
    child: AlertDialog(
      title: const Text('Voice journal'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Status: $state'),
          StreamBuilder(
            stream: Stream.periodic(const Duration(seconds: 1)),
            builder: (_, s) =>
                Text('Duration: ${watch.elapsed.inSeconds} seconds'),
          ),
          if (error != null) Text(error!),
        ],
      ),
      actions: [
        if (state == 'idle')
          TextButton(
            onPressed: busy ? null : () => run(start),
            child: const Text('Start recording'),
          ),
        if (state == 'recording')
          TextButton(
            onPressed: busy
                ? null
                : () => run(() async {
                    await recorder.pause();
                    watch.stop();
                    state = 'paused';
                  }),
            child: const Text('Pause'),
          ),
        if (state == 'paused')
          TextButton(
            onPressed: busy
                ? null
                : () => run(() async {
                    await recorder.resume();
                    watch.start();
                    state = 'recording';
                  }),
            child: const Text('Resume'),
          ),
        if (['recording', 'paused'].contains(state))
          TextButton(
            onPressed: busy
                ? null
                : () => run(() async {
                    final path = await recorder.stop();
                    watch.stop();
                    if (path == null) throw StateError('No recording');
                    draft = File(path);
                    state = 'stopped';
                  }),
            child: const Text('Stop'),
          ),
        if (state == 'stopped')
          TextButton(
            onPressed: busy
                ? null
                : () => run(() async {
                    await widget.store.importFile(
                      entryId: widget.entryId,
                      source: draft!,
                      name: 'Voice ${DateTime.now().toIso8601String()}.m4a',
                      kind: 'audio',
                    );
                    if (context.mounted) Navigator.pop(context);
                  }),
            child: const Text('Save recording'),
          ),
        TextButton(
          onPressed: busy
              ? null
              : () => run(() async {
                  await recorder.cancel();
                  if (context.mounted) Navigator.pop(context);
                }),
          child: const Text('Discard'),
        ),
      ],
    ),
  );
}

class AudioPlayback extends StatefulWidget {
  const AudioPlayback({required this.file, required this.title, super.key});
  final File file;
  final String title;
  @override
  State<AudioPlayback> createState() => _AudioPlaybackState();
}

class _AudioPlaybackState extends State<AudioPlayback> {
  final player = AudioPlayer();
  String? error;
  Duration duration = Duration.zero;
  bool ready = false;
  @override
  void initState() {
    super.initState();
    player
        .setFilePath(widget.file.path)
        .then((d) {
          if (mounted) {
            setState(() {
              duration = d ?? Duration.zero;
              ready = true;
            });
          }
        })
        .catchError((Object e) {
          if (mounted) setState(() => error = 'Audio could not be opened.');
        });
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(widget.title),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (error != null) Text(error!),
        StreamBuilder<Duration>(
          stream: player.positionStream,
          builder: (context, s) {
            final seconds = (s.data ?? Duration.zero).inMilliseconds.toDouble();
            return Column(
              children: [
                Text(
                  '${(seconds / 1000).floor()} / ${duration.inSeconds} seconds',
                ),
                Slider(
                  value: seconds.clamp(0, duration.inMilliseconds.toDouble()),
                  max: duration.inMilliseconds > 0
                      ? duration.inMilliseconds.toDouble()
                      : 1,
                  onChanged: ready
                      ? (v) => player.seek(Duration(milliseconds: v.round()))
                      : null,
                ),
              ],
            );
          },
        ),
        StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          builder: (context, s) => TextButton(
            onPressed: !ready
                ? null
                : () async {
                    try {
                      if (player.playing) {
                        await player.pause();
                      } else {
                        if (player.processingState ==
                            ProcessingState.completed) {
                          await player.seek(Duration.zero);
                        }
                        await player.play();
                      }
                    } catch (_) {
                      if (mounted) setState(() => error = 'Playback failed.');
                    }
                  },
            child: Text(s.data?.playing == true ? 'Pause playback' : 'Play'),
          ),
        ),
      ],
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Close'),
      ),
    ],
  );
}
