import 'package:supabase_flutter/supabase_flutter.dart';

class AdminChecker {
  static bool isAdmin() {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return false;

      // Get user metadata from Supabase
      final userMetadata = user.userMetadata;
      final role = userMetadata?['role'] as String?;

      return role == 'admin';
    } catch (e) {
      return false;
    }
  }

  static bool isLoggedIn() {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      return user != null;
    } catch (e) {
      return false;
    }
  }

  static String? getUserRole() {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return null;

      final userMetadata = user.userMetadata;
      return userMetadata?['role'] as String?;
    } catch (e) {
      return null;
    }
  }
}
