import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wheel_for_a_while/UI/Authentication/Login.dart';
import 'package:wheel_for_a_while/UI/Screens/BikeOption.dart';
import 'package:wheel_for_a_while/UI/Screens/CarOption.dart';
import 'package:wheel_for_a_while/UI/Screens/Notification.dart';
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
  String firstName = '';
  String lastName = '';
  String email = '';

  @override
  void initState() {

    super.initState();
    details();
  }

  void details()async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    firstName = sp.getString('first_name') ?? 'User-name ';
    lastName = sp.getString('last_name') ?? 'not found';
    email = sp.getString('email') ?? 'No Email';
    setState(() {

    });
  }

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
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(
                  builder: (context) => const NotificationSection())
              );
            },
            icon: const Icon(Icons.notification_add_outlined),
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
             UserAccountsDrawerHeader(
              accountName: Text("$firstName $lastName "),
              accountEmail: Text(email.toString()),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  size: 50,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person_2_outlined),
              title: const Text('Profile'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.notification_add_outlined),
              title: const Text('Notification'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.favorite_border_outlined),
              title: const Text('Favourite'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart_outlined),
              title: const Text('Cart'),
              onTap: () {},
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Setting'),
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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 50,),
                const Text('There are two categories, right now!\navailable for booking....',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'ShantellSans',
                  ),
                ),
                const SizedBox(height: 50,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text('Car ->',
                      style: TextStyle(
                          fontSize: 30,
                          color: Color(0xFF03DAC6),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'ShantellSans',
                      ),),
              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const CarOption()));
                },
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.blueGrey[200],
                    boxShadow: const [
                      BoxShadow(
                          color: Color(0xFF03DAC6),
                          blurRadius: 20,
                          offset: Offset(5, 10),
                          spreadRadius: 0.1,
                          blurStyle: BlurStyle.normal
                      ),
                    ],
                  ),
                  child: const Image(
                    image: AssetImage('Assets/images/car.png'),
                    fit: BoxFit.fill,
                  )
                    ),
              )
                  ],
                ),
                const SizedBox(height: 50,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text('Bike ->',
                      style: TextStyle(
                          fontSize: 30,
                          color: Color(0xFF03DAC6),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'ShantellSans',
                      ),),
                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const BikeOption()));
                      },
                      child: Container(
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.blueGrey[200],
                            boxShadow: const [
                              BoxShadow(
                                  color: Color(0xFF03DAC6),
                                  blurRadius: 20,
                                  offset: Offset(5, 10),
                                  spreadRadius: 0.1,
                                  blurStyle: BlurStyle.normal
                              ),
                            ],
                          ),
                          child: const Image(
                            image: AssetImage('Assets/images/motorbike.jpg'),
                            fit: BoxFit.cover,
                          )
                      ),
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
