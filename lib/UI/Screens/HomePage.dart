import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wheel_for_a_while/Notification/notification_services.dart';
import 'package:wheel_for_a_while/UI/Authentication/Login.dart';
import 'package:wheel_for_a_while/UI/Screens/BikeOption.dart';
import 'package:wheel_for_a_while/UI/Screens/CarOption.dart';
import 'package:wheel_for_a_while/UI/Screens/Notification.dart';
import 'package:wheel_for_a_while/UI/Screens/Profile.dart';
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
  NotificationServices notificationServices = NotificationServices();
  String fName = 'Username ';
  String lName = 'not found';
  String email = 'No Email';
  String userDeviceToken = '';

  void details() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    User? user = auth.currentUser;
    sharedPreferences.setString('userID', user!.uid);
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot){
          if(documentSnapshot.exists){
            fName = documentSnapshot.get('firstname');
            lName = documentSnapshot.get('lastname');
            email = documentSnapshot.get('email');
            setState(() {});
          }
          else{
            Utils().toastMessage('Unable to load username & email');
          }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notificationServices.requestNotificationPermission();
    notificationServices.foregroundMessage();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    notificationServices.isTokenRefresh();
    notificationServices.getDeviceToken().then((value){
      userDeviceToken = value ;
      details();
      saveUserDeviceToken();
    });
  }
  
  void saveUserDeviceToken(){
    User? user = auth.currentUser;
    FirebaseFirestore.instance.collection('users').doc(user?.uid).update({'user_device_token' : userDeviceToken});
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onBackButtonDoublePressed(context),
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
                accountName: Text("$fName $lName"),
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
                leading: const Icon(Icons.person_outline_outlined),
                title: const Text('Profile'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Profile(username: "$fName $lName", email: email,)));
                },
              ),
              ListTile(
                leading: const Icon(Icons.notifications_outlined),
                title: const Text('Notification'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationSection()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.favorite_border_outlined),
                title: const Text('Favorites'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.shopping_cart_outlined),
                title: const Text('Cart'),
                onTap: () {},
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.search_outlined),
                title: const Text('Searching'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.exit_to_app_outlined),
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CarOption()),
                        );
                      },
                      icon: const Icon(Icons.directions_car, size: 60),
                      color: Colors.lightGreen[200],
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const BikeOption()),
                        );
                      },
                      icon: const Icon(Icons.motorcycle, size: 60),
                      color: Colors.lightGreen[200],
                    ),
                  ],
                ),
                const SizedBox(height: 25,),
                const Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 25),
                          child: Text(
                            'Cars',
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            'Bikes',
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
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