
import 'package:flutter/material.dart';

class InformationOfAutomobile extends StatefulWidget {
  final List<String> imageURL;
  final String automobileName, make, model, ac, capacity, daily, monthly, location, description, city;

  const InformationOfAutomobile({
    Key? key,
    required this.imageURL,
    required this.automobileName,
    required this.make,
    required this.model,
    required this.ac,
    required this.capacity,
    required this.daily,
    required this.monthly,
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
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(onPressed: (){
                Navigator.pop(context);
              }, icon: const Icon(Icons.arrow_back)),
            ),
            const SizedBox(height: 5,),
            Expanded(
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      widget.automobileName,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF03DAC6),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'DESCRIPTION: ',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4,),
                  Text(
                    widget.description,
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        widget.make,
                        style: const TextStyle(fontSize: 18),
                      ),
                      Text(
                        widget.model,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        widget.ac,
                        style: const TextStyle(fontSize: 18),
                      ),
                      Text(
                        'Capacity: ${widget.capacity}',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Location: ${widget.location}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      Text(
                        'City: ${widget.city}',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF03DAC6), borderRadius: BorderRadius.circular(8),
                          boxShadow: const [
                            BoxShadow(color: Colors.green, offset: Offset(6.0, 6.0),),
                          ],
                        ),
                        child: Text(
                          'Daily Price: ${widget.daily}',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF03DAC6), borderRadius: BorderRadius.circular(8),
                          boxShadow: const [
                            BoxShadow(color: Colors.green, offset: Offset(6.0, 6.0),),
                          ],
                        ),
                        child: Text(
                          'Monthly Price: ${widget.monthly}',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}