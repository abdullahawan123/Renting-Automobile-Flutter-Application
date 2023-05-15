

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:wheel_for_a_while/UI/utils/utilities.dart';

class BackButtonDoublePressed{
  DateTime backButtonPressed = DateTime.now();

  Future<bool> onBackButtonDoublePressed(BuildContext context) async {
    final difference = DateTime.now().difference(backButtonPressed);
    backButtonPressed = DateTime.now();

    if (difference >= const Duration(seconds: 2)){
      Utils().toastMessage1("Click again to close the app");
      return false;
    }else{
      SystemNavigator.pop(animated: true);
      return true;
    }
  }
}