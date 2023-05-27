import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wheel_for_a_while/UI/Authentication/Login.dart';
import 'package:wheel_for_a_while/UI/BO_Screens/BO_Details.dart';
import 'package:wheel_for_a_while/UI/utils/BackButton.dart';

class BO_HomePage extends StatefulWidget {
  @override
  _BO_HomePageState createState() => _BO_HomePageState();
}

class _BO_HomePageState extends State<BO_HomePage> {
  late String currentUserUid = '';

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
    return WillPopScope(
      onWillPop: () => BackButtonDoublePressed().onBackButtonDoublePressed(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Business Owner'),
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.logout_outlined),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()));
            }
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
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                // Automobiles exist, display the details
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final automobile = snapshot.data!.docs[index];
                    final imageUrls =
                    List<String>.from(automobile['image_URL']);
                    final name = automobile['automobile_name'] ?? '';
                    final make = automobile['make'] ?? '';
                    final model = automobile['model'] ?? '';

                    return ListTile(
                      leading: Image.network(imageUrls.first),
                      title: Text(name),
                      subtitle: Text('$make $model'),
                    );
                  },
                );
              }

              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text('No automobiles found.', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'ShantellSans'),),
                      Text('If you want to add an automobile, ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'ShantellSans'),),
                      Text('pressed the button below', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'ShantellSans'),),
                      Text('At the right corner!!!!!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'ShantellSans'),)
                    ],
                  ),
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
      ),
    );
  }
}