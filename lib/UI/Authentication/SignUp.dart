import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:wheel_for_a_while/UI/Authentication/Login.dart';
import 'package:flutter/material.dart';
import 'package:wheel_for_a_while/UI/Widgets/RoundButton.dart';
import 'package:wheel_for_a_while/UI/Widgets/hexStringToColor.dart';

import '../Screens/HomePage.dart';
import '../utils/utilities.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  bool visibility = true;
  bool visibility1 = true;

  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void signUp(){
    setState(() {
      loading = true;
    });
    _auth.createUserWithEmailAndPassword(
        email: emailController.text.toString(),
        password: passwordController.text.toString()).then((value) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const Homepage()));
      setState(() {
        loading = false;
      });
    }
    ).onError((error, stackTrace) {
      Utils().toastMessage(error.toString());
      setState(() {
        loading = false;
      });
    });
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: ()async {
          SystemNavigator.pop();
          return true;
        },
      child: Scaffold(
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
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
                    const SizedBox(height: 15,),
                    Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Image(
                        height: 140,
                        width: 150,
                        image: AssetImage('Assets/images/logo-1.png'),
                        fit: BoxFit.fitWidth,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 10,),
                      const Text(
                        'Register',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20,),
                      Form(
                        key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: firstNameController,
                                keyboardType: TextInputType.text,
                                cursorColor: Colors.white,
                                enableSuggestions: true,
                                autocorrect: true,
                                style: TextStyle(color: Colors.white.withOpacity(0.9)),
                                decoration: InputDecoration(
                                  labelText: "Enter first name",
                                  labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
                                  filled: true,
                                  floatingLabelBehavior: FloatingLabelBehavior.never,
                                  fillColor: Colors.white.withOpacity(0.3),
                                  prefixIcon: const Icon(Icons.person_outline, color: Colors.white70,),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide: const BorderSide(width: 0, style: BorderStyle.none),
                                  ),
                                ),
                                validator: (value){
                                  if (value!.isEmpty){
                                    return 'Enter your first name';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                              TextFormField(
                                controller: lastNameController,
                                keyboardType: TextInputType.text,
                                cursorColor: Colors.white,
                                enableSuggestions: true,
                                autocorrect: true,
                                style: TextStyle(color: Colors.white.withOpacity(0.9)),
                                decoration: InputDecoration(
                                  labelText: "Enter last name",
                                  labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
                                  filled: true,
                                  floatingLabelBehavior: FloatingLabelBehavior.never,
                                  fillColor: Colors.white.withOpacity(0.3),
                                  prefixIcon: const Icon(Icons.person_outline, color: Colors.white70,),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide: const BorderSide(width: 0, style: BorderStyle.none),
                                  ),
                                ),
                                validator: (value){
                                  if (value!.isEmpty){
                                    return 'Enter your last name';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
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
                              SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                              TextFormField(
                                controller: passwordController,
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
                              SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                              TextFormField(
                                controller: confirmController,
                                obscureText: visibility1,
                                keyboardType: TextInputType.text,
                                cursorColor: Colors.white,
                                enableSuggestions: false,
                                autocorrect: false,
                                style: TextStyle(color: Colors.white.withOpacity(0.9)),
                                decoration: InputDecoration(
                                  labelText: "Confirm password",
                                  labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
                                  filled: true,
                                  floatingLabelBehavior: FloatingLabelBehavior.never,
                                  fillColor: Colors.white.withOpacity(0.3),
                                  suffixIcon: IconButton(onPressed: (){
                                    setState(() {
                                      visibility1 =! visibility1;
                                    });
                                  },
                                      color: Colors.white70,
                                      icon: visibility1? const Icon(Icons.visibility_off, color: Colors.white70,)
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
                                    return 'Re-Enter your password';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          )),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
                      RoundButton(
                        title: "Sign-Up",
                        loading: loading,
                        onTap: (){
                          if(_formKey.currentState!.validate()){
                            if (passwordController.text.toString() == confirmController.text.toString()){
                              signUp();
                            }else{
                              Utils().toastMessage("Password and Confirm Password should be same. Otherwise you won't be able to continue");
                            }
                          }
                        },
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.001,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Already have an account? ', style: TextStyle(color: Colors.white, fontSize: 15),),
                          TextButton(
                              onPressed: (){
                                Navigator.push(context,
                                    MaterialPageRoute(
                                        builder: (context) => const Login()));
                                },
                              child: const Text('Login',  style: TextStyle(fontSize: 15),),
                          ),
                        ],
                      )
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
