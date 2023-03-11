import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wheel_for_a_while/UI/Authentication/Login.dart';
import 'package:wheel_for_a_while/UI/Widgets/RoundButton.dart';
import 'package:wheel_for_a_while/UI/Widgets/hexStringToColor.dart';
import 'package:wheel_for_a_while/UI/Widgets/imagesWidget.dart';
import 'package:wheel_for_a_while/UI/utils/utilities.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}



class _ForgetPasswordState extends State<ForgetPassword> {
  bool loading = false;

  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
  }

  void login(){
    setState(() {
      loading = true;
    });
    _auth.sendPasswordResetEmail(email: emailController.text.toString()).then((value) {
      Utils().toastMessage1("We have send you an email to recover password\nKindly check it. And if not Kindly repeat the process");
      Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()));
      setState(() {
        loading = false;
      });
    }).onError((error, stackTrace) {
      setState(() {
        loading = false;
        Utils().toastMessage(error.toString());
      });
    });

  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        Navigator.pop(context);
        return true;
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                hexStringToColor("39834B"),
                hexStringToColor("00A411"),
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
                          'Forgot Password',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  cursorColor: Colors.white,
                                  enableSuggestions: true,
                                  autocorrect: true,
                                  style: TextStyle(color: Colors.white.withOpacity(0.9)),
                                  decoration: InputDecoration(
                                    labelText: "Enter email",
                                    labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
                                    filled: true,
                                    floatingLabelBehavior: FloatingLabelBehavior.never,
                                    fillColor: Colors.white.withOpacity(0.3),
                                    prefixIcon: const Icon(Icons.email_outlined, color: Colors.white70,),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      borderSide: const BorderSide(width: 0, style: BorderStyle.none),
                                    ),
                                  ),
                                  validator: (value){
                                    if (value!.isEmpty){
                                      return 'Enter your email';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            )),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
                        RoundButton(
                          title: "Recover Password",
                          loading: loading,
                          onTap: (){
                            if(_formKey.currentState!.validate()){
                              login();
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
