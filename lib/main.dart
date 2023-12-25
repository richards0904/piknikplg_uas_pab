import 'package:flutter/material.dart';
//import 'package:piknikplg_uas_pab/widget/menu_utama.dart';
import 'package:piknikplg_uas_pab/widget/app_color.dart' as warna;
import 'package:piknikplg_uas_pab/widget/signin_screen.dart';
import 'package:piknikplg_uas_pab/widget/signup_screen.dart';
//import 'package:piknikplg_uas_pab/widget/signup_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PiknikPlg',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
            iconTheme: IconThemeData(color: warna.primary),
            titleTextStyle: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        colorScheme: ColorScheme.fromSeed(seedColor: warna.primary)
            .copyWith(primary: warna.primary, surface: warna.primary),
        useMaterial3: true,
      ),
      home: const SignUpScreen(),
    );
  }
}
