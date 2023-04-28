import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wheel_for_a_while/UI/Authentication/Login.dart';
import 'package:wheel_for_a_while/UI/Widgets/hexStringToColor.dart';
import 'package:wheel_for_a_while/UI/utils/utilities.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  final auth = FirebaseAuth.instance;
  DateTime backButtonPressed = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onBackButtonDoublePressed(context),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: const Text("Wheel For a While"),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  hexStringToColor("03DAC6"),
                  hexStringToColor("03DAC6"),
                  hexStringToColor("1C201D"),
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter
                ),
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)
              ),
            ),
          ),
          actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notification_add_outlined),
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            const UserAccountsDrawerHeader(
              accountName: Text('Abdullah Awan'),
              accountEmail: Text('awana2202@gmail.com'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  size: 50,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {},
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Log out'),
              onTap: () {
                auth.signOut().then((value) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()));
                }).onError((error, stackTrace) {
                Utils().toastMessage(error.toString());
                });
                },
            ),
          ],
        ),
      ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const <Widget>[
              Text("This is Home Page", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),)
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackButtonDoublePressed(BuildContext context) async {
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
