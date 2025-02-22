import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'EventScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

@override
  void initState() {
  Future.delayed(const Duration(seconds: 5), () {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const EventScreen()),
    );
  });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset(
          'assets/lottie/going.json',
          width: 400,
          height: 400,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
