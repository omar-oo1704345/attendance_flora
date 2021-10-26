import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:attendance_flora/src/services/authentication.dart';
import 'package:attendance_flora/src/ui/constants/colors.dart';
import 'package:attendance_flora/src/ui/pages/homepage.dart';
import 'package:attendance_flora/src/ui/pages/login.dart';

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class SplashScreenWidget extends StatefulWidget {
  SplashScreenWidget({this.auth});

  final BaseAuth auth;

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreenWidget> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "";


  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      widget.auth.getCurrentUser().then((user) {
        setState(() {
          if (user != null) {
            _userId = user?.uid;
          }

          authStatus = user?.uid == null
              ? AuthStatus.NOT_LOGGED_IN
              : AuthStatus.LOGGED_IN;

          MaterialPageRoute loginRoute = MaterialPageRoute(
              builder: (BuildContext context) => Login(auth: Auth()));
          MaterialPageRoute homePageRoute = MaterialPageRoute(
              builder: (BuildContext context) => HomePage(user: user));

          if (authStatus == AuthStatus.LOGGED_IN) {
            Navigator.pushReplacement(context, homePageRoute);
          } else {
            if (authStatus == AuthStatus.NOT_LOGGED_IN) {
              Navigator.pushReplacement(context, homePageRoute);
            }
          }
        });
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [splashScreenColorBottom, splashScreenColorTop],
            begin: Alignment.bottomCenter,
            end: Alignment.topRight,
          ),
        ),
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Image.asset(
              "assets/logo/logo-white.png",
              height: 150,
            ),
            Container(
              padding: const EdgeInsets.only(top: 80),
              child: const SpinKitThreeBounce(
                color: Colors.white,
                size: 30.0,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
