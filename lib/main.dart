import 'package:flutter/material.dart';
import 'package:piknikplg_uas_pab/data/wisataplg_data.dart';
import 'package:piknikplg_uas_pab/models/wisataplg.dart';
//import 'package:piknikplg_uas_pab/widget/menu_utama.dart';
import 'package:piknikplg_uas_pab/widget/app_color.dart' as warna;
import 'package:piknikplg_uas_pab/widget/detail_screen.dart';
import 'package:piknikplg_uas_pab/widget/favorite_screen.dart';
import 'package:piknikplg_uas_pab/widget/profile_screen.dart';
import 'package:piknikplg_uas_pab/widget/menu_utama.dart';
import 'package:piknikplg_uas_pab/widget/search_screen.dart';
import 'package:piknikplg_uas_pab/widget/signin_screen.dart';
import 'package:piknikplg_uas_pab/widget/signup_screen.dart';
//import 'package:piknikplg_uas_pab/widget/signup_screen. dart';

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
      home: MainScreen(),
      initialRoute: '/',
      routes: {
        '/signin': (context) => const SignInScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    const MenuUtama(),
    const SearchScreen(),
    const FavoriteWisata(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.white,
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  color: Colors.orangeAccent,
                ),
                label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.search,
                  color: Colors.orangeAccent,
                ),
                label: 'Search'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.favorite,
                  color: Colors.orangeAccent,
                ),
                label: 'Favorite'),
          ],
          selectedItemColor: Colors.orangeAccent,
          unselectedItemColor: Colors.orangeAccent[100],
          showUnselectedLabels: true,
        ),
      ),
    );
  }
}
