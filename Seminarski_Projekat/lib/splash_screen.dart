import 'dart:async';

import 'package:flutter/material.dart';
import 'package:seminarski_projekat/glavna_stranica.dart';

void main() {
  runApp(SplashScreen());
}

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => StartState();
}

class StartState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTime();
  }

  startTime() async {
    var duration = Duration(seconds: 5);
    return new Timer(duration, route);
  }

  route() {
    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => const GlavnaStranica()  //GlavnaStranica
    ));
  }

  @override
  Widget build(BuildContext context) {
    return initWidget(context);
  }

  Widget initWidget(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Center(
            child: Container(
              alignment: Alignment.center, // This is needed
              child: Image.asset(
                "img/logoauto.png",
                fit: BoxFit.contain,
                width: 300,
                height: 200,
              ),
            ),
          ),
        ]
    ),
      ),
    );
  }
}