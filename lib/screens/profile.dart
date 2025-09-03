import 'package:baftopia/widgets/sign_in.dart';
import 'package:baftopia/widgets/sign_up.dart';
import 'package:baftopia/utils/admin_checker.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _showSignUp = false;
  bool _saving = false;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  void _toggleForm() {
    setState(() {
      _showSignUp = !_showSignUp;
    });
  }

  void _handleSignUpSuccess() {
    setState(() {
      _showSignUp = false;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    setState(() => _saving = true);
    try {
      final metadata = Map<String, dynamic>.from(user.userMetadata ?? {});
      if (_nameController.text.trim().isNotEmpty) {
        metadata['display_name'] = _nameController.text.trim();
      }
      if (_phoneController.text.trim().isNotEmpty) {
        metadata['phone'] = _phoneController.text.trim();
      }

      await Supabase.instance.client.auth.updateUser(
        UserAttributes(data: metadata),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('پروفایل با موفقیت به‌روزرسانی شد')),
        );
        setState(() {});
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('خطا در به‌روزرسانی: $e')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = AdminChecker.isLoggedIn();
    final user = isLoggedIn ? Supabase.instance.client.auth.currentUser : null;

    final displayName = user?.userMetadata?['display_name'] as String?;
    final phone = user?.userMetadata?['phone'] as String?;
    final email = user?.email;

    _nameController.text = displayName ?? '';
    _emailController.text = email ?? '';
    _phoneController.text = phone ?? '';

    final userName =
        displayName ??
        user?.userMetadata?['email'] ??
        user?.email?.split('@').first ??
        'کاربر';

    final userInitial = userName.isNotEmpty ? userName[0].toUpperCase() : 'U';

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              if (isLoggedIn)
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 36,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Text(
                          userInitial,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        userName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 24),
              if (isLoggedIn) ...[
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: _inputDecoration(
                          'نام و نام خانوادگی',
                          icon: Icons.person_outline,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _emailController,
                        enabled: false,
                        decoration: _inputDecoration(
                          'ایمیل',
                          icon: Icons.email_outlined,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _phoneController,
                        decoration: _inputDecoration(
                          'شماره تماس (اختیاری)',
                          icon: Icons.phone_outlined,
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _saving ? null : _updateProfile,
                          icon: const Icon(Icons.save_outlined),
                          label:
                              _saving
                                  ? const SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : const Text('به‌روزرسانی پروفایل'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            try {
                              await Supabase.instance.client.auth.signOut();
                              setState(() {});
                            } catch (e) {}
                          },
                          icon: const Icon(Icons.logout),
                          label: const Text('خروج از حساب'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                Text(
                  _showSignUp ? 'ثبت نام' : 'ورود',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                _showSignUp
                    ? SignUpWidget(onSuccess: _handleSignUpSuccess)
                    : SignInWidget(onSuccess: () => setState(() {})),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: _toggleForm,
                    child: Text(
                      _showSignUp ? 'حساب کاربری دارید؟ ورود' : 'ثبت نام',
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, {IconData? icon}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: icon != null ? Icon(icon) : null,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: Theme.of(context).primaryColor,
          width: 1.4,
        ),
      ),
    );
  }
}
