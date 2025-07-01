import 'package:flutter/material.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,

          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/images/Logo.png'),
                Text(
                  'ورود مدیر',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                TextField(decoration: InputDecoration(label: Text('ایمیل'))),
                const SizedBox(height: 16),
                TextField(decoration: InputDecoration(label: Text('رمز عبور'))),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(onPressed: () {}, child: Text('ورود')),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
