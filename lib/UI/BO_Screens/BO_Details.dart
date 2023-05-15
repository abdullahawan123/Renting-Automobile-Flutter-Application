import 'package:flutter/material.dart';

class BO_Details extends StatefulWidget {
  const BO_Details({Key? key}) : super(key: key);

  @override
  State<BO_Details> createState() => _BO_DetailsState();
}

class _BO_DetailsState extends State<BO_Details> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details of the automobile"),
      ),
    );
  }
}
