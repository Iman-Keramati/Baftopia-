import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignInWidget extends StatefulWidget {
  final VoidCallback? onSuccess;

  const SignInWidget({Key? key, this.onSuccess}) : super(key: key);

  @override
  State<SignInWidget> createState() => _SignInWidgetState();
}

class _SignInWidgetState extends State<SignInWidget> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  String? _error;
  String? _success;
  bool _showReset = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _loading = true;
      _error = null;
      _success = null;
    });

    try {
      await Supabase.instance.client.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      setState(() {
        _success = 'ورود موفقیت‌آمیز بود!';
      });

      // Call success callback after a short delay
      Future.delayed(const Duration(seconds: 1), () {
        widget.onSuccess?.call();
      });
    } catch (e) {
      setState(() {
        _error = _getErrorMessage(e.toString());
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  String _getErrorMessage(String error) {
    if (error.contains('Invalid login credentials')) {
      return 'ایمیل یا رمز عبور اشتباه است';
    } else if (error.contains('Email not confirmed')) {
      return 'ایمیل تایید نشده است';
    } else if (error.contains('Too many requests')) {
      return 'تعداد تلاش‌ها زیاد است. لطفاً کمی صبر کنید';
    }
    return 'خطا در ورود. لطفاً دوباره تلاش کنید';
  }

  Future<void> _resetPassword() async {
    if (_emailController.text.trim().isEmpty) {
      setState(() {
        _error = 'لطفاً ایمیل خود را وارد کنید';
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
      _success = null;
    });

    try {
      await Supabase.instance.client.auth.resetPasswordForEmail(
        _emailController.text.trim(),
      );

      setState(() {
        _success = 'ایمیل بازنشانی رمز عبور ارسال شد!';
      });
    } catch (e) {
      setState(() {
        _error = 'خطا در ارسال ایمیل بازنشانی';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
              if (!value.contains('@')) {
                return 'لطفاً ایمیل معتبر وارد کنید';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          if (!_showReset)
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'رمز عبور',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'لطفاً رمز عبور خود را وارد کنید';
                }
                if (value.length < 6) {
                  return 'رمز عبور باید حداقل ۶ کاراکتر باشد';
                }
                return null;
              },
            ),
          const SizedBox(height: 16),

          if (_error != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                border: Border.all(color: Colors.red.shade200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _error!,
                style: TextStyle(color: Colors.red.shade700),
                textAlign: TextAlign.center,
              ),
            ),

          if (_success != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                border: Border.all(color: Colors.green.shade200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _success!,
                style: TextStyle(color: Colors.green.shade700),
                textAlign: TextAlign.center,
              ),
            ),

          const SizedBox(height: 16),

          if (!_showReset) ...[
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
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : const Text('ورود'),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => setState(() => _showReset = true),
              child: const Text('فراموشی رمز عبور؟'),
            ),
          ] else ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _resetPassword,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child:
                    _loading
                        ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : const Text('ارسال ایمیل بازنشانی'),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => setState(() => _showReset = false),
              child: const Text('بازگشت به ورود'),
            ),
          ],
        ],
      ),
    );
  }
}
