import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fuck/screens/categories.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  double _opacity = 1.0;

  @override
  void initState() {
    super.initState();

    // Start fade out after a short delay
    Timer(const Duration(seconds: 2), () {
      setState(() {
        _opacity = 0.0;
      });

      // Wait for fade out, then navigate (no back stack)
      Timer(const Duration(milliseconds: 700), () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (ctx) => const CategoriesScreen()),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE6DB), // soft peachy tone
      body: Center(
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/Logo.png', width: 300, height: 300),
              const SizedBox(height: 20),
              Text(
                'جایی که هر رج، داستانی برای گفتن دارد',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontSize: 20,
                  fontFamily: GoogleFonts.lalezar.toString(),
                  color: const Color.fromARGB(255, 226, 127, 102),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
