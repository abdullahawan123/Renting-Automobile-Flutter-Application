import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wheel_for_a_while/UI/Authentication/Login.dart';
import 'package:wheel_for_a_while/UI/Widgets/hexStringToColor.dart';
import 'package:wheel_for_a_while/UI/utils/utilities.dart';

class NotificationSection extends StatefulWidget {
  const NotificationSection({Key? key}) : super(key: key);

  @override
  State<NotificationSection> createState() => _NotificationSectionState();
}

class _NotificationSectionState extends State<NotificationSection> {
  List<Map<String, dynamic>> notificationData = [];
  final _auth = FirebaseAuth.instance;
  final firebaseFirestore = FirebaseFirestore.instance;
  String address = '';
  String date = '';
  String time = '';
  double totalRent = 0;
  String status = '';

  void getNotificationDetails() {
    try {
      firebaseFirestore
          .collection('Renting Request')
          .doc(_auth.currentUser!.uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          address = documentSnapshot.get('Address');
          Timestamp timestamp = documentSnapshot.get('Date'); // Assuming the field is named 'Date' in Firestore
          date = timestamp.toDate().toString(); // Convert Timestamp to DateTime and then to String
          time = documentSnapshot.get('Time');
          totalRent = documentSnapshot.get('Total_rent');
          status = documentSnapshot.get('status');
          setState(() {
            Map<String, dynamic> data = {
              'Address': address,
              'Date': date,
              'Time': time,
              'Total Rent': totalRent,
              'Status': status,
            };
            notificationData.add(data);
          });
        } else {
          Utils().toastMessage('Unable to load data');
        }
      });
    } catch (e) {
      Utils().toastMessage1(e.toString());
    }
  }


  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  @override
  Widget build(BuildContext context) {
    String dateString = '';
    String timeString = '';
    if (date.isNotEmpty && time.isNotEmpty) {
      DateTime dateTime = DateTime.parse(date);
      dateString = DateFormat('yyyy-MM-dd').format(dateTime);
      timeString = DateFormat('HH:mm').format(dateTime);
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: const Text("Notification"),
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
      ),
      body: notificationData.isEmpty
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_off,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No notifications yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      )
          : ListView.builder(
        itemCount: notificationData.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Address: $address'),
            subtitle: Text('Date: $dateString, Time: $timeString '),
            leading: const Icon(Icons.notifications_outlined),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Address: $address'),
                  content:
                  Text('Date: $dateString, Time: $timeString \nStatus: $status'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _checkAuthentication() async {
    final user = _auth.currentUser;
    if (user == null) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()));
    } else {
      getNotificationDetails();
    }
  }
}
