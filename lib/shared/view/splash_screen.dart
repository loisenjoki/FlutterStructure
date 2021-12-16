import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_app/_devmode/view/dev_screen.dart';
import 'package:my_app/core/app_delegate.dart';
import 'package:ping9/ping9.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    AppDelegate.instance.setupFuture.then(onSetup);
  }

  FutureOr onSetup(_) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => DevScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Indicator(),
    );
  }
}
