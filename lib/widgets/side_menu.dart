import 'package:flutter/material.dart';
import 'package:baftopia/widgets/sign_in.dart';
import 'package:baftopia/widgets/sign_up.dart';
import 'package:baftopia/utils/admin_checker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  bool _showSignUp = false;

  void _toggleForm() {
    setState(() {
      _showSignUp = !_showSignUp;
    });
  }

  void _closeMenu() {
    Navigator.of(context).pop();
  }

  void _handleSignUpSuccess() {
    _closeMenu();
  }

  void _handleSignInSuccess() {
    _closeMenu();
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = AdminChecker.isLoggedIn();
    final isAdmin = AdminChecker.isAdmin();
    final userRole = AdminChecker.getUserRole();

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Drawer(
        child: SafeArea(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Close button at the top
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close, size: 28),
                        onPressed: _closeMenu,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      if (isLoggedIn)
                        Text(
                          'پروفایل',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Logo centered
                  Center(
                    heightFactor: 0.5,
                    child: Image.asset('assets/images/Logo.png'),
                  ),
                  const SizedBox(height: 24),

                  if (isLoggedIn) ...[
                    // User is logged in
                    Center(
                      child: Column(
                        children: [
                          const CircleAvatar(
                            radius: 36,
                            child: Icon(Icons.person, size: 40),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'کاربر وارد شده',
                            style: Theme.of(context).textTheme.titleMedium,
                            textAlign: TextAlign.center,
                          ),
                          if (userRole != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              'نقش: ${userRole == 'admin' ? 'مدیر' : 'کاربر'}',
                              style: Theme.of(context).textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                          ],
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                try {
                                  await Supabase.instance.client.auth.signOut();
                                  setState(() {});
                                  _closeMenu();
                                } catch (e) {
                                  // Handle sign out error silently
                                }
                              },
                              icon: const Icon(Icons.logout),
                              label: const Text('خروج از حساب'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    // User is not logged in
                    Text(
                      _showSignUp ? 'ثبت نام' : 'ورود',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),

                    Expanded(
                      child: SingleChildScrollView(
                        child:
                            _showSignUp
                                ? SignUpWidget(onSuccess: _handleSignUpSuccess)
                                : SignInWidget(onSuccess: _handleSignInSuccess),
                      ),
                    ),

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
        ),
      ),
    );
  }
}
