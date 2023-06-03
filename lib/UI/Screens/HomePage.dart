import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wheel_for_a_while/UI/Authentication/Login.dart';
import 'package:wheel_for_a_while/UI/Screens/BikeOption.dart';
import 'package:wheel_for_a_while/UI/Screens/CarOption.dart';
import 'package:wheel_for_a_while/UI/Screens/Notification.dart';
import 'package:wheel_for_a_while/UI/Widgets/hexStringToColor.dart';
import 'package:wheel_for_a_while/UI/utils/BackButton.dart';
import 'package:wheel_for_a_while/UI/utils/utilities.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final auth = FirebaseAuth.instance;
  String firstName = '';
  String lastName = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    details();
  }

  void details() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    firstName = sp.getString('first_name') ?? 'User-name ';
    lastName = sp.getString('last_name') ?? 'not found';
    email = sp.getString('email') ?? 'No Email';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => BackButtonDoublePressed().onBackButtonDoublePressed(context),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: const Text("Wheel For a While"),
          centerTitle: true,
          flexibleSpace: Container(
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
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationSection(),
                  ),
                );
              },
              icon: const Icon(Icons.notifications),
            ),
          ],
        ),
        drawer: Drawer(
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text("$firstName $lastName"),
                accountEmail: Text(email),
                currentAccountPicture: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 50,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Profile'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.notifications),
                title: const Text('Notification'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.favorite_border),
                title: const Text('Favorites'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.shopping_cart),
                title: const Text('Cart'),
                onTap: () {},
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {},
              ),
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
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 30),
                const Text(
                  'Choose your preferred category:',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const CarOption()),
                            );
                          },
                          icon: const Icon(Icons.directions_car, size: 60),
                          color: Colors.blueGrey[200],
                        ),
                        const SizedBox(height: 25),
                        const Text(
                          'Cars',
                          style: TextStyle(fontSize: 24),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const BikeOption()),
                            );
                          },
                          icon: const Icon(Icons.motorcycle, size: 60),
                          color: Colors.blueGrey[200],
                        ),
                        const SizedBox(height: 25),
                        const Text(
                          'Bikes',
                          style: TextStyle(fontSize: 24),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}