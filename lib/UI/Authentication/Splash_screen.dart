import 'dart:math' as math;
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wheel_for_a_while/UI/Widgets/imagesWidget.dart';
import 'package:wheel_for_a_while/UI/Widgets/hexStringToColor.dart';

import 'SplashServices.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {

  late final AnimationController _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this)..repeat();

  SplashServices splashServices = SplashServices();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    splashServices.isLogin(context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                hexStringToColor("39834B"),
                hexStringToColor("00A411"),
                hexStringToColor("1C201D"),
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter
              )
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: AnimatedBuilder(
                      animation: _controller,
                      builder: (BuildContext context, Widget? child) {
                        return Transform.rotate(
                            angle: _controller.value * 2.0 * math.pi,
                            child: logoWidget('Assets/images/logo-1.png'),
                  );
                      }
                )),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
               Center(
                 child: DefaultTextStyle(
                   style: const TextStyle(
                     fontSize: 30.0,
                     fontWeight: FontWeight.bold,
                     color: Colors.white,
                   ),
                   child: AnimatedTextKit(
                       repeatForever: false,
                       totalRepeatCount: 1,
                       animatedTexts: [
                     RotateAnimatedText(
                         'WHEEL FOR A WHILE', textStyle: const TextStyle(fontFamily: 'ShantellSans', fontWeight: FontWeight.w300, fontStyle: FontStyle.italic),
                         textAlign: TextAlign.center,
                         rotateOut: false)
                   ]),
                 ),
               )
              ],
            ),
          ),
        )
      ),
    );
  }
}
