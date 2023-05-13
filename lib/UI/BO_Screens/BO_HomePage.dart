import 'package:flutter/material.dart';

class BO_HomePage extends StatefulWidget {
  const BO_HomePage({Key? key}) : super(key: key);

  @override
  State<BO_HomePage> createState() => _BO_HomePageState();
}

class _BO_HomePageState extends State<BO_HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Owner Home Page'),
      ),
    );
  }
}
