import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wheel_for_a_while/Notification/notification_services.dart';
import 'package:wheel_for_a_while/UI/Authentication/Login.dart';
import 'package:wheel_for_a_while/UI/BO_Screens/BO_Details.dart';
import 'package:wheel_for_a_while/UI/BO_Screens/BO_Notification.dart';
import 'package:wheel_for_a_while/UI/BO_Screens/InfomationOfAutomobile.dart';
import 'package:wheel_for_a_while/UI/Screens/Profile.dart';
import 'package:wheel_for_a_while/UI/utils/utilities.dart';

class BO_HomePage extends StatefulWidget {
  @override
  _BO_HomePageState createState() => _BO_HomePageState();
}

class _BO_HomePageState extends State<BO_HomePage> {
  String currentUserUid = '';
  String businessOwnerFCMToken = '' ;
  final auth = FirebaseAuth.instance;
  NotificationServices services = NotificationServices();
  DateTime backButtonPressed = DateTime.now();
  String fName = 'Username ';
  String lName = 'not found';
  String email = 'No Email';

  @override
  void initState() {
    super.initState();
    services.requestNotificationPermission();
    services.foregroundMessage();
    services.firebaseInit(context);
    services.setupInteractMessage(context);
    services.isTokenRefresh();
    services.getDeviceToken().then((value){
      businessOwnerFCMToken = value ;
    });
    details();
  }

  void details(){
    User? user = auth.currentUser;
    FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot){
      if(documentSnapshot.exists){
        fName = documentSnapshot.get('firstname');
        lName = documentSnapshot.get('lastname');
        email = documentSnapshot.get('email');
        setState(() {
          currentUserUid = user!.uid.toString();
        });
      }
      else{
        Utils().toastMessage('Unable to load username & email');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onBackButtonDoublePressed(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Business Owner'),
          centerTitle: true,
          automaticallyImplyLeading: false,
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
                leading: const Icon(Icons.person),
                title: const Text('Profile'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Profile(username: "$fName $lName", email: email,)));
                },
              ),
              ListTile(
                leading: const Icon(Icons.notifications),
                title: const Text('Notification'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const BO_Notification()));
                },
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
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('automobile')
                .where('user_id', isEqualTo: currentUserUid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Text('Error: ${snapshot.error}'),
                    ),
                  ],
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: CircularProgressIndicator(strokeWidth: 4, color: Color(0xFF03DAC6),),
                    ),
                  ],
                );
              }
              if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Wrap(
                      alignment: WrapAlignment.start,
                      spacing: 10,
                      runSpacing: 10,
                      children: snapshot.data!.docs.map((automobile) {
                        final imageUrls = List<String>.from(automobile['image_URL']);
                        final name = automobile['automobile_name'] ?? '';
                        final make = automobile['make'] ?? '';
                        final model = automobile['model'] ?? '';
                        final carUnit = automobile['ac or non-ac'] ?? '';
                        final capacity = automobile['capacity'] ?? '';
                        final dailyPrice = automobile['daily_price'] ?? '';
                        final monthlyPrice = automobile['monthly_price'] ?? '';
                        final location = automobile['location'] ?? '';
                        final description = automobile['description'] ?? '';
                        final city = automobile['city'] ?? '';
                        final gears = automobile['no_of_gear'] ?? '';

                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InformationOfAutomobile(
                                  imageURL: imageUrls,
                                  automobileName: name,
                                  make: make,
                                  model: model,
                                  ac: carUnit,
                                  capacity: capacity,
                                  daily: dailyPrice,
                                  monthly: monthlyPrice,
                                  location: location,
                                  description: description,
                                  city: city,
                                  gears: gears,
                                ),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 2 - 15,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Image.network(imageUrls.first),
                                      const SizedBox(height: 10),
                                      Text(
                                        name,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Make: $make',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Model: $model',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                );
              }

              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('No automobiles found.', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'ShantellSans'),),
                    Text('If you want to add an automobile, ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'ShantellSans'),),
                    Text('pressed the button below', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'ShantellSans'),),
                    Text('At the right corner!!!!!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'ShantellSans'),)
                  ],
                ),
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BO_Details(businessOwnerFCMToken: businessOwnerFCMToken,)),
            );
          },
          child: const Icon(Icons.add),
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