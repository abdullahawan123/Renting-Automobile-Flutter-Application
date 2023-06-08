import 'package:flutter/material.dart';
import 'package:wheel_for_a_while/UI/Screens/Booking.dart';

class DetailsOfAutomobile extends StatefulWidget {
  List<String> imageURL;
  String automobileName, make, model, ac, capacity, daily, monthly, gears, location, description, city;

  DetailsOfAutomobile({
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
  State<DetailsOfAutomobile> createState() => _DetailsOfAutomobileState();
}

class _DetailsOfAutomobileState extends State<DetailsOfAutomobile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5),
              Row(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      widget.automobileName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
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
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildFeatureIcon(Icons.ac_unit, widget.ac),
                        _buildFeatureIcon(Icons.settings, widget.gears),
                        _buildFeatureIcon(Icons.drive_eta, widget.make),
                        _buildFeatureIcon(Icons.model_training, widget.model),
                        _buildFeatureIcon(Icons.reduce_capacity, widget.capacity),
                      ],
                    ),
                    const SizedBox(height: 20),
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
                    _buildDetailRow('Daily Rent', widget.daily),
                    _buildDetailRow('Monthly Rent', widget.monthly),
                    _buildDetailRow('Location', widget.location),
                    _buildDetailRow('City', widget.city),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          double rent = double.parse(widget.daily);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Booking(automobileName: widget.automobileName, dailyRent: rent,)));
                        },
                        child: const Text('Book Now'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureIcon(IconData iconData, String text) {
    return Column(
      children: [
        Icon(iconData),
        const SizedBox(height: 4),
        Text(
          text,
          style: const TextStyle(fontSize: 14),
        ),
      ],
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
