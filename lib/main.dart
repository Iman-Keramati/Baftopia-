import 'package:baftopia/core/theme.dart';
import 'package:baftopia/screens/welcome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://utzofrqnssnjihpvjrsg.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InV0em9mcnFuc3NuamlocHZqcnNnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDgyNjU1ODksImV4cCI6MjA2Mzg0MTU4OX0._24-lFKT3nPluELVYBM3yD_ZWna3HBV4sPpdlIlNSCk',
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Baftopia',
      theme: AppTheme.lightTheme,
      home: const WelcomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
