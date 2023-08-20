import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:wheel_for_a_while/UI/Authentication/Login.dart';
import 'package:wheel_for_a_while/UI/Widgets/hexStringToColor.dart';
import 'package:wheel_for_a_while/UI/utils/utilities.dart';
import 'package:wheel_for_a_while/Notification/notification_services.dart';

class NotificationSectionBO extends StatefulWidget {
  const NotificationSectionBO({Key? key}) : super(key: key);

  @override
  State<NotificationSectionBO> createState() => _NotificationSectionBOState();
}

class _NotificationSectionBOState extends State<NotificationSectionBO> {
  List<Map<String, dynamic>> notificationData = [];
  final _auth = FirebaseAuth.instance;
  final firebaseFirestore = FirebaseFirestore.instance;
  String automobile = '' ;
  String userID = '' ;
  String userDeviceToken = '' ;
  String phoneNo = '' ;

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
    getPhoneNumberOfUser();
  }

  void _launchPhoneCall() async {
    if (phoneNo.isNotEmpty) {
      var url = "https://wa.me/$phoneNo?text=Hello%20World!";
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch whatsapp';
      }
    } else {
      Utils().toastMessage('Phone number is not available.');
    }
  }


  void getPhoneNumberOfUser() async {
    await firebaseFirestore.collection('users').doc(userID).get().then((DocumentSnapshot documentSnapshot){
      if(documentSnapshot.exists){
        phoneNo = documentSnapshot.get('Phone_No');
      }
      else{
        Utils().toastMessage('Unable to load phone number');
      }
    });
  }

  void getNotificationDetails() async {
    NotificationServices notificationServices = NotificationServices();
    String token = await notificationServices.getDeviceToken();
    try {
      QuerySnapshot snapshot = await firebaseFirestore
          .collection('Renting Request')
          .where('Business_Owner_Device_Token', isEqualTo: token)
          .get();

      setState(() {
        notificationData = snapshot.docs.map<Map<String, dynamic>>((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          userID = data['User ID'];
          userDeviceToken = data['User_Device_Token'];
          automobile = data['Automobile'];
          return data;
        }).toList();
      });
    } catch (e) {
      Utils().toastMessage(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: const Text("Business Owner Notification"),
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
          Map<String, dynamic> data = notificationData[index];
          String dateString = "August 17, 2023 at 5:51:44 AM UTC-7";
          DateTime dateTime = DateFormat("MMMM d, y 'at' h:mm:ss a 'UTC'Z").parse(dateString);
          String formattedDate = DateFormat('MMMM d, y').format(dateTime);
          String formattedTime = DateFormat('h:mm a').format(dateTime);

          return ListTile(
            title: Text('Automobile: ${data['Automobile'] ?? 'Automobile not found'}, ${data['Make']}, ${data['Model']}'),
            subtitle: Text('Date: $formattedDate , Time: $formattedTime ,\n Status: ${data['status'] ?? 'Status not found'}'),
            leading: const Icon(Icons.notifications_outlined),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    firebaseFirestore.collection('Renting Request').doc(userID).update({'status' : 'Accepted'}).then((value) {
                      sendNotificationToUser('accept');
                      setState(() {

                      });
                    }).onError((error, stackTrace){
                      Utils().toastMessage(error.toString());
                    });
                  },
                  icon: const Icon(Icons.check, color: Colors.green),
                ),
                IconButton(
                  onPressed: () {
                    firebaseFirestore.collection('Renting Request').doc(userID).update({'status' : 'Rejected'}).then((value) {
                      sendNotificationToUser('reject');
                      notificationData.clear();
                      setState(() {

                      });
                    }).onError((error, stackTrace){
                      Utils().toastMessage(error.toString());
                    });
                  },
                  icon: const Icon(Icons.close, color: Colors.red),
                ),
                IconButton(
                  onPressed: () {
                    _launchPhoneCall();
                  },
                  icon: const Icon(Icons.phone, color: Colors.blue),
                ),
              ],
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Address: ${data['Address'] ?? 'Address not found'}'),
                  content: Text('Date: $formattedDate , Time: $formattedTime ,\nTotal Rent: ${data['Total_rent'] ?? 'Amount not found'},\nDays: ${data['Rental_days'] ?? 'Days not mentioned'}\nStatus: ${data['status'] ?? 'Status not found'}'),
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
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Login()));
    } else {
      getNotificationDetails();
    }
  }


  void sendNotificationToUser(String request) async {
    var data ={
      'to' : userDeviceToken,
      'notification' : {
        'title' : 'Business owner reply back',
        'body' : 'Rent a Car $request your request for $automobile',
      },
      'data' : {
        'type' : 'notification',
        'id' : 'user',
      },

    };
    await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
        body: jsonEncode(data),
        headers: {
          'Content-Type': 'application/json',
          'Authorization' : 'key=AAAAwaQ0nKk:APA91bFuX0FTXuU78-vi7w0kl-IkgB_alrYrAyUDXVODxxJQNZ_3TxS3bYxgafp0_KDr3OMptSJ7RI2h_huUbwHSIz96_qnzaz5DCsIXbA5abE45RsMqCcrDM6RNGRYgFcaRI0GPM7aV'
        }
    ).then((value) {
      if (value.statusCode == 200) {
        Utils().toastMessage1('Reply send');
      }
      else{
        Utils().toastMessage('Reply sending failed, try again!');
      }
    }).onError((error, stackTrace) {
      Utils().toastMessage(error.toString());
    });
  }
}