import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wheel_for_a_while/UI/Authentication/Login.dart';
import 'package:wheel_for_a_while/UI/BO_Screens/BO_Details.dart';
import 'package:wheel_for_a_while/UI/BO_Screens/InfomationOfAutomobile.dart';
import 'package:wheel_for_a_while/UI/utils/utilities.dart';

class BO_HomePage extends StatefulWidget {
  @override
  _BO_HomePageState createState() => _BO_HomePageState();
}

class _BO_HomePageState extends State<BO_HomePage> {
  late String currentUserUid;
  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    getUserUid();
  }

  Future<void> getUserUid() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        currentUserUid = user.uid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Owner'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            const UserAccountsDrawerHeader(
              accountName: Text(" "),
              accountEmail: Text(''),
              currentAccountPicture: CircleAvatar(
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
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Center(
                    child: CircularProgressIndicator(strokeWidth: 4, color: Color(0xFF03DAC6),),
                  ),
                ],
              );
            }
            if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
              return SingleChildScrollView(
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


                    return InkWell(
                      onTap: (){
                        Navigator.push(context,
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
                                )));
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2 - 15,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
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
                    );
                  }).toList(),
                ),
              );
            }

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
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
            MaterialPageRoute(builder: (context) => BO_Details()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}




