import 'package:flutter/material.dart';

class InformationOfAutomobile extends StatefulWidget {
  List<String> imageURL;
  String automobileName, make, model, ac, capacity, daily, monthly, gears, location, description, city;
   InformationOfAutomobile({Key? key,
    required this.imageURL,
    required this.automobileName,
    required this.make,
    required this.model,
    required this.ac,
    required this.capacity,
    required this.daily,
    required this.monthly,
    required this.gears,
    required this.location,
    required this.description,
    required this.city,
  }) : super(key: key);

  @override
  State<InformationOfAutomobile> createState() => _InformationOfAutomobileState();
}

class _InformationOfAutomobileState extends State<InformationOfAutomobile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Information'),
      ),
    );
  }
}
