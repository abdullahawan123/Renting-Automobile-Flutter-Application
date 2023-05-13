import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wheel_for_a_while/UI/Authentication/Login.dart';
import 'package:flutter/material.dart';
import 'package:wheel_for_a_while/UI/Widgets/RoundButton.dart';
import 'package:wheel_for_a_while/UI/Widgets/hexStringToColor.dart';

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
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  var options = [
    'User',
    'Business Owner',
  ];
  var _currentItemSelected = "User";
  var role = "User";

  final FirebaseAuth _auth = FirebaseAuth.instance;


  void signUp(String email, String password, String role) async {
    const CircularProgressIndicator();
    if (_formKey.currentState!.validate()) {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {postDetailsToFirestore(email, role)})
          .catchError((e){
            Utils().toastMessage(e.toString());
      });
    }
  }

  postDetailsToFirestore(String email, String role) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    var user = _auth.currentUser;
    CollectionReference ref = FirebaseFirestore.instance.collection('users');
    ref.doc(user!.uid).set({'email': _emailController.text, 'role': role});
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Login()));
  }

  @override
  void dispose(){
    super.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
                                  controller: _firstNameController,
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
                                  controller: _lastNameController,
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
                                    else if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
                                      return ("Please enter a valid email");
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                                SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
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
                                SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                                TextFormField(
                                  controller: _confirmController,
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
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Role : ",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            DropdownButton<String>(
                              dropdownColor: const Color(0xFF03DAC6),
                              isDense: true,
                              isExpanded: false,
                              iconEnabledColor: Colors.white,
                              focusColor: Colors.white,
                              items: options.map((String dropDownStringItem) {
                                return DropdownMenuItem<String>(
                                  value: dropDownStringItem,
                                  child: Text(
                                    dropDownStringItem,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (newValueSelected) {
                                setState(() {
                                  _currentItemSelected = newValueSelected!;
                                  role = newValueSelected;
                                });
                              },
                              value: _currentItemSelected,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        RoundButton(
                          title: "Sign-Up",
                          loading: loading,
                          onTap: () async{
                            if(_formKey.currentState!.validate()){
                              if (_passwordController.text.toString() == _confirmController.text.toString()){
                                signUp(_emailController.text, _passwordController.text, role);
                              }else{
                                Utils().toastMessage("Password and Confirm Password should be same. Otherwise you won't be able to continue");
                              }
                            }
                            String fName = _firstNameController.text;
                            String lName = _lastNameController.text;
                            String em =  _emailController.text;
                            SharedPreferences sp = await SharedPreferences.getInstance();
                            sp.setString('first_name', fName);
                            sp.setString('last_name', lName);
                            sp.setString('email', em);
                            setState(() {

                            });
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




