class PersianNumber {
  static String toPersian(String input) {
    final persianDigits = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
    return input
        .split('')
        .map((char) {
          final index = int.tryParse(char);
          return index != null ? persianDigits[index] : char;
        })
        .join('');
  }
}
