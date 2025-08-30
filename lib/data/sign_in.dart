import 'package:baftopia/models/user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> signInWithEmail(UserModel user) async {
  final supabase = Supabase.instance.client;
  final AuthResponse res = await supabase.auth.signInWithPassword(
    email: user.email,
    password: user.password,
  );
}

Future<void> resetPassword(String email) async {
  final supabase = Supabase.instance.client;
  await supabase.auth.resetPasswordForEmail(email);
}
