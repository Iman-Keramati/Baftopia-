import 'package:baftopia/utils/auth_error_mapper.dart';
import 'package:flutter/material.dart';
import 'package:baftopia/models/user.dart';
import 'package:baftopia/data/sign_up.dart';

class SignUpWidget extends StatefulWidget {
  final VoidCallback? onSuccess; // Callback for successful signup

  const SignUpWidget({super.key, this.onSuccess});

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _displayNameController = TextEditingController();
  bool _loading = false;
  String? _error;
  String? _success;

  void _showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _displayNameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
      _success = null;
    });

    try {
      final user = UserModel(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      await signUpWithEmail(user, _displayNameController.text.trim());

      setState(() {
        _success =
            'ثبت نام با موفقیت انجام شد. لطفا ایمیل خود را برای تایید حساب کنید.';
      });

      // Show toast message
      _showToast('ثبت نام با موفقیت انجام شد!');

      // Call the success callback to close sidebar
      if (widget.onSuccess != null) {
        widget.onSuccess!();
      }

      // Clear form after successful signup
      _emailController.clear();
      _passwordController.clear();
      _displayNameController.clear();
    } catch (e) {
      setState(() {
        _error = AuthErrorMapper.toPersianMessage(e);
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _displayNameController,
                decoration: const InputDecoration(
                  labelText: 'نام و نام خانوادگی',
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'نام و نام خانوادگی را وارد کنید'
                            : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'ایمیل',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'لطفاً ایمیل خود را وارد کنید';
                  }
                  if (!value.contains('@') || !value.contains('.')) {
                    return 'ایمیل معتبر وارد کنید';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'رمز عبور',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'لطفاً رمز عبور وارد کنید';
                  }
                  if (value.length < 6) {
                    return 'رمز عبور باید حداقل 6 کاراکتر باشد';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    _error!,
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),

              if (_success != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    _success!,
                    style: const TextStyle(color: Colors.green, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child:
                      _loading
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : const Text(
                            'ثبت نام',
                            style: TextStyle(fontSize: 16),
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
