import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wheel_for_a_while/UI/Screens/Verification.dart';
import 'package:wheel_for_a_while/UI/Widgets/RoundButton.dart';
import 'package:wheel_for_a_while/UI/Widgets/imagesWidget.dart';
import 'package:wheel_for_a_while/UI/Widgets/hexStringToColor.dart';
import 'package:wheel_for_a_while/UI/utils/utilities.dart';

class PhoneRegistration extends StatefulWidget {
  const PhoneRegistration({Key? key}) : super(key: key);

  @override
  State<PhoneRegistration> createState() => _PhoneRegistrationState();
}

class _PhoneRegistrationState extends State<PhoneRegistration> {

  bool loading = false;
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      onWillPop: ()async{
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                hexStringToColor("03DAC6"),
                hexStringToColor("03DAC6"),
                hexStringToColor("1C201D"),
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter
              )
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: SafeArea(
              child: ListView(
                  children:[
                    const SizedBox(height: 30,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        logoWidget('Assets/images/logo-1.png'),
                        const SizedBox(height: 20,),
                        const Text(
                          'Phone Number Registration',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: _phoneController,
                                  keyboardType: TextInputType.number,
                                  cursorColor: Colors.white,
                                  enableSuggestions: true,
                                  autocorrect: true,
                                  style: TextStyle(color: Colors.white.withOpacity(0.9)),
                                  decoration: InputDecoration(
                                    labelText: "Enter phone number",
                                    labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
                                    filled: true,
                                    floatingLabelBehavior: FloatingLabelBehavior.never,
                                    fillColor: Colors.white.withOpacity(0.3),
                                    prefixIcon: const Icon(Icons.phone_outlined, color: Colors.white70,),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      borderSide: const BorderSide(width: 0, style: BorderStyle.none),
                                    ),
                                  ),
                                  validator: (value){
                                    if (value!.isEmpty){
                                      return 'Enter your valid phone number';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            )),
                        const SizedBox(height: 30),
                        RoundButton(
                          title: "Enter",
                          loading: loading,
                          onTap: (){
                            setState(() {
                              loading = true ;
                            });
                            if(_formKey.currentState!.validate()){
                              _auth.verifyPhoneNumber(
                                phoneNumber: _phoneController.text,
                                  verificationCompleted: (_){
                                    setState(() {
                                      loading = false ;
                                    });
                                  },
                                  verificationFailed: (error){
                                    setState(() {
                                      loading = false ;
                                    });
                                  Utils().toastMessage(error.toString());
                                  },
                                  codeSent: (String verificationID, int? token){
                                    setState(() {
                                      loading = false ;
                                    });
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ScreenVerification(verificationID: verificationID, phoneNo: _phoneController.text.toString(),)));
                                  },
                                  codeAutoRetrievalTimeout: (e){
                                    setState(() {
                                      loading = false ;
                                    });
                                  }
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ]
              ),
            ),
          ),
        ),
      ),
    );
  }
}

