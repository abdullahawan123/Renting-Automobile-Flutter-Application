import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wheel_for_a_while/UI/Widgets/hexStringToColor.dart';

class Booking extends StatefulWidget {
  final String automobileName;
  final double dailyRent;

  const Booking({super.key, required this.automobileName, required this.dailyRent});

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

  void storingDetails(){
    User? user = _auth.currentUser;
    firebaseFirestore.collection('Renting Request').doc(user!.uid).set({
      'Rental_days' : rentalDays,
      'Address' : location,
      'Total_rent' : totalRent,
      'Date' : selectedDate.toString(),
      'Time' : selectedTime.toString(),
      'status' : 'Pending',
    });
  }

  void sendNotificationToBusinessOwner() async {
    var data ={
      'to' : 'eAKfWeaDSj-dX_MnvZTQ2g:APA91bHv1KaE8doj0NWUer9IA6Rjw9IYZ9R0Ql86leI5r9ZUO7_5Nv1OkfCEO9h3A76ouLyHvWFPy484CGKVdYF52j4FkhiksjjInPm2qZOvF8c6euAXoxijAzVc5_zN9H9ornJqADVx',
      'notification' : {
        'title' : 'Rent a Car',
        'body' : 'User want to rent a car, if u like!',
      },
      'data' : {
        'type' : 'notification',
        'id' : 'Asif Taj',
      }
    };
    await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
    body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json',
        'Authorization' : 'key=AAAAwaQ0nKk:APA91bFuX0FTXuU78-vi7w0kl-IkgB_alrYrAyUDXVODxxJQNZ_3TxS3bYxgafp0_KDr3OMptSJ7RI2h_huUbwHSIz96_qnzaz5DCsIXbA5abE45RsMqCcrDM6RNGRYgFcaRI0GPM7aV'
      }
    ).then((value) {
      debugPrint(value.body.toString());
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
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
