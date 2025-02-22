import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ConnectionFailed extends StatelessWidget {
  const ConnectionFailed({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(
        child:Lottie.asset('assets/lottie/no-internet.json'),
      ) ,
    );
  }
}
