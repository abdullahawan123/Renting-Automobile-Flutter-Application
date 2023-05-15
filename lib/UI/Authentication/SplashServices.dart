import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wheel_for_a_while/UI/BO_Screens/BO_HomePage.dart';
import 'package:wheel_for_a_while/UI/Screens/HomePage.dart';

import 'Login.dart';

class SplashServices {
  Future<void> isLogin(BuildContext context) async {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    DocumentSnapshot<Map<String, dynamic>> document = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
    String userRole = document.data()!['role'];


    // ignore: unnecessary_null_comparison
    if(user != null){
      Timer(const Duration (milliseconds: 3700),
              () => Navigator.push(context, MaterialPageRoute(builder: (context) => userRole == 'User'? const Homepage() : BO_HomePage()))
      );
    }else{
      Timer(const Duration (seconds: 3),
              () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()))
      );
    }
  }
}