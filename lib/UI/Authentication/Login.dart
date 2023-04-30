import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wheel_for_a_while/UI/Authentication/SignUp.dart';
import 'package:wheel_for_a_while/UI/Authentication/forgot_password.dart';
import 'package:wheel_for_a_while/UI/BO_Screens/BO_Login.dart';
import 'package:wheel_for_a_while/UI/Widgets/RoundButton.dart';
import 'package:wheel_for_a_while/UI/Widgets/imagesWidget.dart';
import 'package:wheel_for_a_while/UI/Widgets/hexStringToColor.dart';
import 'package:wheel_for_a_while/UI/utils/utilities.dart';

import '../Screens/HomePage.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  bool loading = false;
  bool visibility = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }
  
  void login(){
    setState(() {
      loading = true;
    });
    _auth.signInWithEmailAndPassword(
        email: _emailController.text.toString(),
        password: _passwordController.text.toString()).then((value) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const Homepage()));
      setState(() {
        loading = false;
      });
    }).onError((error, stackTrace) {
      setState(() {
        loading = false;
      });
      Utils().toastMessage(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
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
                          'Login',
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
                                  controller: _emailController,
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
                                const SizedBox(height: 20),
                                TextFormField(
                                  controller: _passwordController,
                                  obscureText: visibility,
                                  keyboardType: TextInputType.text,
                                  cursorColor: Colors.white,
                                  enableSuggestions: false,
                                  autocorrect: false,
                                  style: TextStyle(color: Colors.white.withOpacity(0.9)),
                                  decoration: InputDecoration(
                                    labelText: "Enter password",
                                    labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
                                    filled: true,
                                    floatingLabelBehavior: FloatingLabelBehavior.never,
                                    fillColor: Colors.white.withOpacity(0.3),
                                    suffixIcon: IconButton(onPressed: (){
                                      setState(() {
                                        visibility =! visibility;
                                      });
                                    },
                                        color: Colors.white70,
                                        icon: visibility? const Icon(Icons.visibility_off, color: Colors.white70,)
                                            :const Icon(Icons.visibility, color: Colors.white70,)
                                    ),
                                    prefixIcon: const Icon(Icons.lock, color: Colors.white70,),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      borderSide: const BorderSide(width: 0, style: BorderStyle.none),
                                    ),
                                  ),
                                  validator: (value){
                                    if (value!.isEmpty){
                                      return 'Enter your password';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            )),
                        const SizedBox(height: 10),
                        RoundButton(
                          title: "Login",
                          loading: loading,
                          onTap: (){
                            if(_formKey.currentState!.validate()){
                              login();
                            }
                          },
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: TextButton(
                              onPressed: (){
                                Navigator.push(context,
                                    MaterialPageRoute(
                                        builder: (context) => const ForgetPassword()));
                              },
                              child: const Text('Forgot Password?', style: TextStyle(fontSize: 15,color: Colors.white),)),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have an account.", style: TextStyle(fontSize: 15, color: Colors.white),),
                            TextButton(
                                onPressed: (){
                                  Navigator.push(context,
                                      MaterialPageRoute(
                                          builder: (context) => const SignUp()));
                                },
                                child: const Text('Sign-Up', style: TextStyle(fontSize: 15),)),
                          ],
                        ),
                        const SizedBox(height: 10,),
                        Row(
                            children: const <Widget>[
                              Expanded(
                                  child: Divider(color: Colors.white70,)
                              ),

                              Text("OR Login AS", style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'ShantellSans',
                              ),),

                              Expanded(
                                  child: Divider(color: Colors.white70,)
                              ),
                            ]
                        ),
                        const SizedBox(height: 5,),
                        RoundButton(title: 'BUSINESS OWNER', onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const BO_Login()));
                        })
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
