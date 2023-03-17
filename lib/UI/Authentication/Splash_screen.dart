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
                SafeArea(
                    child: logoWidget('Assets/images/logo-1.png')
                  ),
               Center(
                 child: DefaultTextStyle(
                   style: const TextStyle(
                     fontSize: 30.0,
                     fontWeight: FontWeight.bold,
                     color: Colors.white,
                   ),
                   child: AnimatedTextKit(
                     displayFullTextOnTap: true,
                     pause: const Duration(seconds: 6),
                     isRepeatingAnimation: false,
                       animatedTexts: [
                         TypewriterAnimatedText('Wheel For A\nWhile', textAlign: TextAlign.center),
                       ],
                   )
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
