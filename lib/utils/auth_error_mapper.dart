import 'package:supabase_flutter/supabase_flutter.dart';

class AuthErrorMapper {
  static String toPersianMessage(Object error) {
    if (error is AuthException) {
      switch (error.code) {
        case 'email_already_exists':
        case 'duplicate_email':
          return 'این ایمیل قبلاً ثبت شده است.';
        case 'email_address_invalid':
          return 'ایمیل وارد شده معتبر نیست. لطفاً یک ایمیل درست وارد کنید.';
        case 'email_address_not_authorized':
          return 'این ایمیل مجاز به ثبت‌نام نیست.';
        case 'invalid_login_credentials':
          return 'ایمیل یا رمز عبور اشتباه است.';
        case 'email_not_confirmed':
          return 'ایمیل شما هنوز تأیید نشده. لطفاً ایمیل خود را چک کنید.';
        case 'weak_password':
          return 'رمز عبور بسیار ضعیف است. لطفاً رمز قوی‌تری انتخاب کنید.';
        case 'user_already_registered':
          return 'حساب کاربری با این ایمیل قبلاً ایجاد شده است.';
        default:
          return 'خطا در ثبت نام: ${error.message}';
      }
    } else if (error is PostgrestException) {
      if (error.code == '42501') {
        return 'خطای دسترسی. لطفاً با پشتیبانی تماس بگیرید.';
      }
      return 'خطای دیتابیس: ${error.message}';
    } else if (error is Exception) {
      final errStr = error.toString();

      if (errStr.contains('Failed host lookup')) {
        return 'عدم دسترسی به سرور. لطفاً اتصال اینترنت خود را بررسی کنید.';
      }
      if (errStr.contains('SocketException')) {
        return 'مشکل در ارتباط با سرور. لطفاً دوباره تلاش کنید.';
      }

      return 'خطا: $errStr';
    }

    return 'یه مشکل غیرمنتظره پیش اومد: $error';
  }
}
