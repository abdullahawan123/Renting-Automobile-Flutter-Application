import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wheel_for_a_while/UI/Screens/BikeOption.dart';
import 'package:wheel_for_a_while/UI/Screens/CarOption.dart';
import 'package:wheel_for_a_while/UI/Screens/PhoneRegistrationScreen.dart';
import 'package:wheel_for_a_while/UI/Widgets/hexStringToColor.dart';
import 'package:wheel_for_a_while/UI/Widgets/imagesWidget.dart';
import 'package:wheel_for_a_while/UI/utils/utilities.dart';

class ScreenVerification extends StatefulWidget {
  final String verificationID;
  final String phoneNo;
  const ScreenVerification({Key? key, required this.verificationID, required this.phoneNo}) : super(key: key);

  @override
  State<ScreenVerification> createState() => _ScreenVerificationState();
}

class _ScreenVerificationState extends State<ScreenVerification> {
  final _auth = FirebaseAuth.instance;
  final pinController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool loading = false;
  String uid = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF03DAC6),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              hexStringToColor("03DAC6"),
              hexStringToColor("03DAC6"),
              hexStringToColor("1C201D"),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: logoWidget('Assets/images/logo-1.png')),
              const SizedBox(
                height: 45,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  "Verification",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w600),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  "Enter the OTP code sent to your phone",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w400),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Form(
                key: formKey,
                child: Pinput(
                  controller: pinController,
                  keyboardType: TextInputType.number,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  length: 6,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Kindly Enter the OTP';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Did not receive a code?",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  )),
              const SizedBox(
                height: 35,
              ),
              const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "RESEND",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w800),
                  )),
              const SizedBox(
                height: 28,
              ),
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () async {
                    if (formKey.currentState!.validate()) {
                      setState(() {
                        loading = true;
                      });
                      final credentials = PhoneAuthProvider.credential(
                        verificationId: widget.verificationID,
                        smsCode: pinController.text.toString(),
                      );

                      try {
                        await _auth.signInWithCredential(credentials);
                        await savePhoneNoToFirestore(widget.phoneNo);
                        await updateIsNumberToTrue();
                        setState(() {
                          loading = false;
                        });
                        goToScreen();
                      } catch (err) {
                        setState(() {
                          loading = false;
                        });
                        Utils().toastMessage(err.toString());
                      }
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xff222448),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: loading
                        ? const CircularProgressIndicator(
                        strokeWidth: 4, color: Color(0xFF03DAC6))
                        : const Text(
                      "Done",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PhoneRegistration(),
                      ),
                    );
                  },
                  child: const Text(
                    "Change phone number?",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void goToScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BikeOption()),
    );
  }

  Future<void> savePhoneNoToFirestore(String phoneNumber) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    uid = sharedPreferences.getString('userID')!;
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({
        'Phone_No': phoneNumber,
      });
    } catch (exception) {
      Utils().toastMessage(exception.toString());
    }
  }
  Future<void> updateIsNumberToTrue() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setBool('isNumber', true);
  }
}
