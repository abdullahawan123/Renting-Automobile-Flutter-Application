import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wheel_for_a_while/Notification/notification_services.dart';
import 'package:wheel_for_a_while/UI/Screens/Notification.dart';
import 'package:wheel_for_a_while/UI/Screens/PhoneRegistrationScreen.dart';
import 'package:wheel_for_a_while/UI/Widgets/hexStringToColor.dart';
import 'package:wheel_for_a_while/UI/utils/utilities.dart';

class Booking extends StatefulWidget {
  final String automobileName;
  final double dailyRent;
  final String make;
  final String model;
  final String deviceToken;
  final String businessOwnerID;

  const Booking({
    super.key,
    required this.automobileName,
    required this.dailyRent,
    required this.make,
    required this.model,
    required this.deviceToken,
    required this.businessOwnerID,
  });

  @override
  _BookingState createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  final addressController = TextEditingController();
  final _key = GlobalKey<FormState>();
  final firebaseFirestore = FirebaseFirestore.instance;
  int rentalDays = 1;
  String location = '';
  double totalRent = 0 ;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  String phoneNo = '' ;
  bool isNumberAvailable = false ;
  bool loading = false ;
  bool isDriver = false ;

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
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getString('userID')!;
    DateTime parsedDate = DateTime.parse(selectedDate.toString());
    firebaseFirestore.collection('Renting Request').doc(id).set({
      'Rental_days' : rentalDays,
      'Address' : location,
      'Total_rent' : totalRent,
      'Automobile' : widget.automobileName,
      'Make' : widget.make,
      'Model' : widget.model,
      'User ID' : id,
      'Date' : parsedDate,
      'Time' : selectedTime.toString(),
      'status' : 'Pending',
      'User_Device_Token' : userToken,
      'Business_Owner_Device_Token' : widget.deviceToken,
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    addressController.dispose();
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

  void getPhoneNoOfBusinessOwner(){
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.businessOwnerID)
        .get().then((DocumentSnapshot documentSnapshot){
      if (documentSnapshot.exists){
        phoneNo = documentSnapshot.get('Phone_No');
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPhoneNoOfBusinessOwner();
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
            Row(
              children: [
                const Text('Driver: ', style: TextStyle(fontSize: 16),),
                const SizedBox(width: 8),
                Switch(
                  value: isDriver,
                  onChanged: (newValue) {
                    setState(() {
                      isDriver = newValue;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 15,),
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
                onPressed: () async {
                  setState(() {
                    loading = true ;
                  });
                  SharedPreferences sp = await SharedPreferences.getInstance();
                  bool decision = sp.getBool('isNumber') ?? false;
                  sp.setString('automobile', widget.automobileName);
                  sp.setDouble('rent', widget.dailyRent);
                  sp.setString('make', widget.make);
                  sp.setString('model', widget.model);
                  sp.setString('deviceToken', widget.deviceToken);
                  sp.setString('businessOwnerID', widget.businessOwnerID);
                  if(!isDriver){
                    alertDialogue();
                  }
                  else if(decision){
                    if(_key.currentState!.validate()){
                      storingDetails();
                      sendNotificationToBusinessOwner();
                      setState(() {
                        loading = false ;
                      });
                    }else{
                      setState(() {
                        loading = false ;
                      });
                    }
                  }else{
                    goToPhoneRegistration();
                  }
                },
                child: loading ? const CircularProgressIndicator(strokeWidth: 4, color: Color(0xFF03DAC6),)  : const Text('Rent it Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
  void goToPhoneRegistration(){
    Navigator.push(context,
        MaterialPageRoute(
            builder: (context) => const PhoneRegistration()
        )
    );
  }

  void alertDialogue(){
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cannot Rent Without Driver'),
          content: const Text(
            'You cannot rent a car without a driver. If you want to rent without a driver, please contact the owner.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                setState(() {
                  loading = false;
                });
              },
              child: const Text('OK'),
            ),
            TextButton(onPressed: (){
              _launchPhoneCall();
            }, child: const Icon(Icons.call)),
          ],
        );
      },
    );
  }

  void _launchPhoneCall() async {
    if (phoneNo.isNotEmpty) {
      var url = "https://wa.me/$phoneNo?text=Hello%20World!";
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        Utils().toastMessage('WhatsApp is not installed!');
      }
    } else {
      throw 'Could not launch whatsapp';
    }
  }
}
