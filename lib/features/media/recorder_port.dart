import 'package:record/record.dart';

// Injectable boundary keeps permission and recording lifecycle tests hardware-free.
abstract class RecorderPort {
  Future<bool> hasPermission();
  Future<void> start(RecordConfig config, {required String path});
  Future<void> pause();
  Future<void> resume();
  Future<String?> stop();
  Future<void> cancel();
  Future<void> dispose();
}

class DeviceRecorder implements RecorderPort {
  final AudioRecorder _recorder = AudioRecorder();
  @override
  Future<bool> hasPermission() => _recorder.hasPermission();
  @override
  Future<void> start(RecordConfig config, {required String path}) =>
      _recorder.start(config, path: path);
  @override
  Future<void> pause() => _recorder.pause();
  @override
  Future<void> resume() => _recorder.resume();
  @override
  Future<String?> stop() => _recorder.stop();
  @override
  Future<void> cancel() => _recorder.cancel();
  @override
  Future<void> dispose() => _recorder.dispose();
}
