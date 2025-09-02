import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserState {
  final bool isLoggedIn;
  final bool isAdmin;

  UserState({required this.isLoggedIn, required this.isAdmin});
}

class UserNotifier extends StateNotifier<UserState> {
  UserNotifier() : super(UserState(isLoggedIn: false, isAdmin: false)) {
    _updateUserState();

    Supabase.instance.client.auth.onAuthStateChange.listen((event) {
      _updateUserState();
    });
  }

  void _updateUserState() {
    final user = Supabase.instance.client.auth.currentUser;

    final isLoggedIn = user != null;
    final role = user?.userMetadata?['role'] as String?;
    final isAdmin = role == 'admin';

    state = UserState(isLoggedIn: isLoggedIn, isAdmin: isAdmin);
  }
}

// Riverpod provider
final userProvider = StateNotifierProvider<UserNotifier, UserState>(
  (ref) => UserNotifier(),
);
