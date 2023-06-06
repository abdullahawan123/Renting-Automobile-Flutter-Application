import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CarOption extends StatefulWidget {
  const CarOption({super.key});

  @override
  _CarOptionState createState() => _CarOptionState();
}

class _CarOptionState extends State<CarOption> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Find the perfect car for your needs and enjoy a hassle-free rental experience.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('automobile')
                    .where('category', isEqualTo: 'CategorySelection.Car')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 4,
                        color: Color(0xFF03DAC6),
                      ),
                    );
                  }
                  if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                    return ListView(
                      padding: const EdgeInsets.all(16),
                      children: snapshot.data!.docs.map((automobile) {
                        final imageUrls = List<String>.from(automobile['image_URL']);
                        final name = automobile['automobile_name'] ?? '';
                        final make = automobile['make'] ?? '';
                        final model = automobile['model'] ?? '';
                        final dailyPrice = automobile['daily_price'] ?? '';

                        return GestureDetector(
                          onTap: () {
                            // Handle the car selection
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    imageUrls.first,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: 200,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Center(
                                  child: Text(
                                    name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Make: $make',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Model: $model',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.attach_money, color: Colors.green),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Daily Price: $dailyPrice',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                const Divider(color: Colors.blueGrey,),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  }

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Center(
                        child: Text(
                          'No car found.',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      const Center(
                        child: Text(
                          'Try to refresh the page?',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Center(
                          child: IconButton(
                              onPressed: (){
                                setState(() {
                                  const CircularProgressIndicator(strokeWidth: 10, color: Colors.black12,);
                                });
                              }, icon: const Icon(Icons.refresh, color: Colors.blueGrey,))
                      )
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}