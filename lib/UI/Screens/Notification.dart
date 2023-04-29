import 'package:flutter/material.dart';

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
        title: const Text('Notifications'),
      ),
      body: SafeArea(
        child: Expanded(
          child: Column(
            children: const [

            ],
          ),
        ),
      ),
    );
  }
}
