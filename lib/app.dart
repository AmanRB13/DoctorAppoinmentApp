import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';

import 'package:provider/provider.dart';
import 'package:docotorappointment/providers/theme_providers.dart';
import 'screens/details_screen.dart';
import 'screens/favorites_screens.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    final themeProvider =
        Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData.light(),

      darkTheme: ThemeData.dark(),

      themeMode: themeProvider.isDarkMode
          ? ThemeMode.dark
          : ThemeMode.light,

      initialRoute: '/',

      routes: {
        '/': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/details' :(context) => const DetailsScreen(),
        '/favorite' : (context) =>  FavoriteScreen(),
      },
    );
  }
}