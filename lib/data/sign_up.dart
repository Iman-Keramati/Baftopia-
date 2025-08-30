import 'package:baftopia/models/user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> signUpWithEmail(UserModel user, String displayName) async {
  final supabase = Supabase.instance.client;

  try {
    final AuthResponse res = await supabase.auth.signUp(
      email: user.email,
      password: user.password,
      data: {'display_name': displayName},
      emailRedirectTo: 'baftopia://login-callback', // Your custom scheme
    );

    if (res.user == null) {
      throw Exception("Sign-up failed. Please try again.");
    }
  } catch (e) {
    print('Signup error: $e');
    rethrow;
  }
}
