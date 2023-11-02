import 'package:dine_easy/payment/Wallet.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './client/./client_signin/loginpg.dart';
import './restaurant/./profile/profile.dart';
import './restaurant/./signin/./loginpg.dart';
import 'package:dine_easy/client/Home/HomePage.dart';
import './restaurant/token_manager.dart';
import 'Splash_Screen.dart';
import 'client/client_reservations/client_reservations.dart';

void main() {
  runApp(const MyApp());
}

String? token;
String? name;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:Wallet(),
      //SplashScreen(), // Start with the SplashScreen
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF020403),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Restaurant"),
              Tab(text: "Customer"),
            ],
          ),
          title: const Text("Dine Easy"),
        ),
        body: const TabBarView(
          children: [
            Home_2(),
            Home_1(),
          ],
        ),
      ),
    );
  }
}
