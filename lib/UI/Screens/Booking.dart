import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wheel_for_a_while/Notification/notification_services.dart';
import 'package:wheel_for_a_while/UI/Screens/Notification.dart';
import 'package:wheel_for_a_while/UI/Widgets/hexStringToColor.dart';
import 'package:wheel_for_a_while/UI/utils/utilities.dart';

class Booking extends StatefulWidget {
  final String automobileName;
  final double dailyRent;
  final String make;
  final String model;
  final String deviceToken;

  const Booking({
    super.key,
    required this.automobileName,
    required this.dailyRent,
    required this.make,
    required this.model,
    required this.deviceToken,
  });

  @override
  _BookingState createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  final addressController = TextEditingController();
  final _key = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final firebaseFirestore = FirebaseFirestore.instance;
  int rentalDays = 1;
  String location = '';
  double totalRent = 0 ;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  void _showDatePicker() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  void _showTimePicker() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  double calculateTotalFare() {
    totalRent = rentalDays * widget.dailyRent ;
    return totalRent ;
  }

  void storingDetails() async {
    NotificationServices notificationServices = NotificationServices();
    String userToken = await notificationServices.getDeviceToken();
    User? user = _auth.currentUser;
    DateTime parsedDate = DateTime.parse(selectedDate.toString());
    firebaseFirestore.collection('Renting Request').doc(user!.uid).set({
      'Rental_days' : rentalDays,
      'Address' : location,
      'Total_rent' : totalRent,
      'Automobile' : widget.automobileName,
      'Make' : widget.make,
      'Model' : widget.model,
      'User ID' : user.uid,
      'Date' : parsedDate,
      'Time' : selectedTime.toString(),
      'status' : 'Pending',
      'User_Device_Token' : userToken,
      'Business_Owner_Device_Token' : widget.deviceToken,
    });
  }

  void sendNotificationToBusinessOwner() async {
    var data ={
      'to' : widget.deviceToken,
      'notification' : {
        'title' : 'Request send by a user',
        'body' : 'User want to rent a car, ${widget.automobileName}',
      },
      'data' : {
        'type' : 'notification',
        'id' : 'business_owner',
        'bookingDetails': { // Add the booking details as a nested object
          'automobileName': widget.automobileName,
          'rentalDays': rentalDays,
          'address': location,
          'totalRent': totalRent.toStringAsFixed(2),
        },
      },

    };
    await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
    body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json',
        'Authorization' : 'key=AAAAwaQ0nKk:APA91bFuX0FTXuU78-vi7w0kl-IkgB_alrYrAyUDXVODxxJQNZ_3TxS3bYxgafp0_KDr3OMptSJ7RI2h_huUbwHSIz96_qnzaz5DCsIXbA5abE45RsMqCcrDM6RNGRYgFcaRI0GPM7aV'
      }
    ).then((value) {
      if (value.statusCode == 200){
        Utils().toastMessage1('Request send');
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const NotificationSection()));
      }
      else{
        Utils().toastMessage('Request sending failed, try again!');
      }
    }).onError((error, stackTrace) {
      Utils().toastMessage(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: const Text("Booking"),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Automobile: ${widget.automobileName}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Daily Rent: ${widget.dailyRent.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'Rental Days:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      rentalDays = rentalDays > 1 ? rentalDays - 1 : 1;
                    });
                  },
                  icon: const Icon(Icons.remove),
                ),
                Text(
                  rentalDays.toString(),
                  style: const TextStyle(fontSize: 16),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      rentalDays += 1;
                    });
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Location:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Form(
              key: _key,
              child: TextFormField(
                maxLines: 3,
                controller: addressController,
                onChanged: (value) {
                  setState(() {
                    location = value;
                  });
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your location, Complete Address',
                ),
                validator: (value){
                  if(value!.isEmpty){
                    return 'Enter complete and valid address';
                  }
                  return null ;
                },
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Date and Time:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: _showDatePicker,
                    child: Text(
                      'Date: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextButton(
                    onPressed: _showTimePicker,
                    child: Text(
                      'Time: ${selectedTime.hour}:${selectedTime.minute}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Total Fare:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              calculateTotalFare().toStringAsFixed(2),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if(_key.currentState!.validate()){
                    storingDetails();
                    sendNotificationToBusinessOwner();
                  }
                },
                child: const Text('Rent it Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
