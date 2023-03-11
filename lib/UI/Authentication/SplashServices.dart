import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wheel_for_a_while/UI/Screens/HomePage.dart';

import 'Login.dart';

class SplashServices {
  void isLogin(BuildContext context){
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    if(user != null){
      Timer(const Duration (milliseconds: 3700),
              () => Navigator.push(context, MaterialPageRoute(builder: (context) => Homepage()))
      );
    }else{
      Timer(const Duration (seconds: 3),
              () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()))
      );
    }
  }
}