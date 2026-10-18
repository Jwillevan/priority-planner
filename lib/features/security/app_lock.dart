import 'reminders.dart';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';

import '../../data/database.dart';

abstract class AuthPort {
  Future<bool> authenticate();
}

class DeviceAuth implements AuthPort {
  final auth = LocalAuthentication();
  @override
  Future<bool> authenticate() async {
    if (!await auth.isDeviceSupported()) {
      throw StateError('Set up a device screen lock first');
    }
    return auth.authenticate(
      localizedReason: 'Unlock your private Top 9/Priority Planner',
      biometricOnly: false,
      persistAcrossBackgrounding: true,
    );
  }
}

class LockController extends ChangeNotifier {
  LockController(this.db, this.auth);
  final PlannerDatabase db;
  final AuthPort auth;
  bool enabled = false, locked = true, loaded = false, authenticating = false;
  String? error;
  StreamSubscription? subscription;
  void start() {
    subscription ??= db
        .select(db.plannerSettings)
        .watch()
        .listen(
          (rows) {
            final next =
                rows.where((r) => r.key == 'privacy.lock').firstOrNull?.value ==
                'yes';
            if (next && !enabled) locked = true;
            enabled = next;
            loaded = true;
            notifyListeners();
          },
          onError: (_) {
            error = 'Privacy settings could not be read. Retry after checking storage.';
            locked = true;
            notifyListeners();
          },
        );
  }

  void lock() {
    if (enabled && !authenticating) {
      locked = true;
      notifyListeners();
    }
  }

  Future<bool> verify() async {
    authenticating = true;
    error = null;
    notifyListeners();
    try {
      return await auth.authenticate();
    } catch (_) {
      error = 'Authentication unavailable. Check your device screen lock and retry.';
      return false;
    } finally {
      authenticating = false;
      notifyListeners();
    }
  }

  Future<void> unlock() async {
    if (await verify()) {
      locked = false;
      notifyListeners();
    }
  }

  Future<void> setEnabled(bool value) async {
    if (!await verify()) return;
    final old = enabled;
    try {
      enabled = value;
      locked = false;
      await db.writeSetting('privacy.lock', value ? 'yes' : 'no');
    } catch (_) {
      enabled = old;
      error = 'Could not save app lock preference.';
    }
    notifyListeners();
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }
}

final authProvider = Provider<AuthPort>((ref) => DeviceAuth());
final lockProvider = Provider<LockController>((ref) {
  final lock = LockController(
    ref.watch(databaseProvider),
    ref.watch(authProvider),
  );
  ref.onDispose(lock.dispose);
  return lock;
});

class AppLockGate extends ConsumerStatefulWidget {
  const AppLockGate({required this.child, super.key});
  final Widget child;
  @override
  ConsumerState<AppLockGate> createState() => _AppLockGateState();
}

class _AppLockGateState extends ConsumerState<AppLockGate>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    ref.read(lockProvider).start();
    ref.read(remindersProvider).start();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) {
      ref.read(lockProvider).lock();
    } else {
      ref.read(remindersProvider).refresh();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lock = ref.watch(lockProvider);
    return AnimatedBuilder(
      animation: lock,
      builder: (context, _) {
        final covered = !lock.loaded || (lock.enabled && lock.locked);
        return Stack(
          children: [
            ExcludeSemantics(
              excluding: covered,
              child: IgnorePointer(ignoring: covered, child: widget.child),
            ),
            if (covered)
              Positioned.fill(
                child: Material(
                  color: Theme.of(context).colorScheme.surface,
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.lock_outline, size: 48),
                          const Text('Top 9/Priority Planner'),
                          if (lock.error != null) Text(lock.error!),
                          if (lock.loaded)
                            FilledButton(
                              onPressed: lock.authenticating
                                  ? null
                                  : lock.unlock,
                              child: Text(
                                lock.authenticating
                                    ? 'Authenticating…'
                                    : 'Unlock',
                              ),
                            )
                          else
                            const Text('Reading privacy settings…'),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
