import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nexus/state/auth/models/auth_states.dart';
import 'package:nexus/state/auth/notifiers/auth_state_notifier.dart';

final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>(
  (_) => AuthStateNotifier(),
);
