import 'package:flutter/material.dart';

class InformationOfAutomobile extends StatefulWidget {
  List<String> imageURL;
  String automobileName, make, model, ac, capacity, daily, monthly, gears, location, description, city;

  InformationOfAutomobile({
    Key? key,
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
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5,),
              Row(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(onPressed: (){
                      Navigator.pop(context);
                    }, icon: const Icon(Icons.arrow_back)),
                  ),
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Information about Automobile',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          ),),
                  )
                ],
              ),
              const SizedBox(height: 5,),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                child: PageView.builder(
                  itemCount: widget.imageURL.length,
                  itemBuilder: (context, index) {
                    return Image.network(
                      widget.imageURL[index],
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        widget.automobileName,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Description:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.description,
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Details:',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildDetailRow('Make', widget.make),
                    _buildDetailRow('Model', widget.model),
                    _buildDetailRow('AC', widget.ac),
                    _buildDetailRow('Capacity', widget.capacity),
                    _buildDetailRow('Daily Rent', widget.daily),
                    _buildDetailRow('Monthly Rent', widget.monthly),
                    _buildDetailRow('Gears', widget.gears),
                    _buildDetailRow('Location', widget.location),
                    _buildDetailRow('City', widget.city),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}