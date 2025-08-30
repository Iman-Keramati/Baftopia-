import 'package:flutter/material.dart';
import 'package:baftopia/widgets/sign_in.dart';
// import 'package:baftopia/widgets/sign_up.dart'; // Create this widget similarly to SignInWidget

class AuthTabs extends StatelessWidget {
  const AuthTabs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ورود / ثبت نام'),
          bottom: const TabBar(tabs: [Tab(text: 'ورود'), Tab(text: 'ثبت نام')]),
        ),
        body: const TabBarView(
          children: [
            SignInWidget(),
            // SignUpWidget(), // Implement this widget for sign up
          ],
        ),
      ),
    );
  }
}
