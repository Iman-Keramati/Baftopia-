import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

final theme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF1C1A1E), // soft charcoal
  canvasColor: const Color(0xFF2A262C), // dusty plum
  cardColor: const Color(0xFF3A333A), // knitted shadows
  hintColor: const Color(0xFFEEDACB), // cozy beige for placeholders
  primaryColor: const Color(0xFFD8A7B1), // blush rose
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFFD8A7B1), // rose blush
    secondary: Color(0xFFF5D7DB), // soft pink milk
    surface: Color(0xFF3A333A), // card shadows
    onPrimary: Colors.black,
    onSecondary: Colors.black,
    onSurface: Colors.white,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: const Color(0xFFEFDCD5), // warm rose beige
    foregroundColor: Colors.brown[900],
    titleTextStyle: GoogleFonts.lalezar(
      textStyle: const TextStyle(fontSize: 26, color: Color(0xFF5D4037)),
    ),
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(
      fontSize: 18,
      color: Color(0xFFF3ECEA), // warm light cream
    ),
    titleLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Color(0xFFF7D6C3), // peach whisper
    ),
  ),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      home: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'بافتوپیا',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
