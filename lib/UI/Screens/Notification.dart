import 'package:flutter/material.dart';
import 'package:wheel_for_a_while/UI/Widgets/hexStringToColor.dart';

class NotificationSection extends StatefulWidget {
  const NotificationSection({Key? key}) : super(key: key);

  @override
  State<NotificationSection> createState() => _NotificationSectionState();
}

class _NotificationSectionState extends State<NotificationSection> {
  @override
  Widget build(BuildContext context) {
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
    );
  }
}
