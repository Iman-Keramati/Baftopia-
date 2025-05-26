import 'package:flutter/material.dart';
import 'package:fuck/screens/welcome.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

final theme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: const Color(0xFFFBEAE5), // ✨ creamy white
  canvasColor: const Color(0xFFFFF2EC), // 🩷 peach milk backdrop
  cardColor: const Color(0xFFFFEDE7), // 🍦 pastel blush
  hintColor: const Color(0xFFBFAAA0), // 🪵 warm taupe placeholder
  primaryColor: const Color(0xFFD8A7B1), // 🌸 rose blush
  colorScheme: const ColorScheme.light(
    primary: Color(0xFFD8A7B1), // rose blush
    secondary: Color(0xFFF7D6C3), // peach whisper
    surface: Color(0xFFFFEDE7), // card shadows
    onPrimary: Colors.white,
    onSecondary: Color(0xFF5E4A47), // text on pink
    onSurface: Color(0xFF3E3E3E), // warm dark gray
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: const Color(0xFFFBEAE5), // 🧁 cotton cloud
    foregroundColor: const Color(0xFF5D4037), // cocoa brown
    elevation: 0,
    titleTextStyle: GoogleFonts.poppins(
      textStyle: const TextStyle(fontSize: 26, color: Color(0xFF5D4037)),
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFFD8A7B1), // matches primary
    foregroundColor: Colors.white,
    elevation: 4,
  ),
  textTheme: TextTheme(
    bodyLarge: GoogleFonts.poppins(
      textStyle: const TextStyle(
        fontSize: 16,
        color: Color(0xFF5E4A47), // warm brownish text
      ),
    ),
    titleLarge: GoogleFonts.lalezar(
      textStyle: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: Color(0xFF725B52), // muted cocoa
      ),
    ),
  ),
  cardTheme: CardTheme(
    elevation: 3,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
  ),
  iconTheme: const IconThemeData(
    color: Color(0xFFB08884), // warm desaturated brown-pink
  ),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(theme: theme, home: WelcomeScreen());
  }
}
