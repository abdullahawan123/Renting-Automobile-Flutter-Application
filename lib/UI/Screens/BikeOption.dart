import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wheel_for_a_while/UI/Screens/Booking.dart';
import 'package:wheel_for_a_while/UI/Screens/DetailsOfAutomobile.dart';
import 'package:wheel_for_a_while/UI/Screens/FavouriteScreen.dart';
import 'package:wheel_for_a_while/UI/Screens/HomePage.dart';

class BikeOption extends StatefulWidget {
  const BikeOption({Key? key}) : super(key: key);

  @override
  _BikeOptionState createState() => _BikeOptionState();
}

class _BikeOptionState extends State<BikeOption> {
  List<String> favorites = [];
  String name = '';
  String make = '';
  String model = '';

  void toggleFavorite(String automobileId) {
    setState(() {
      if (favorites.contains(automobileId)) {
        favorites.remove(automobileId);
      } else {
        favorites.add(automobileId);
      }
    });
  }

  bool isFavorite(String automobileId) {
    return favorites.contains(automobileId);
  }

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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const Homepage()));
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.favorite_border_outlined),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => FavoritesScreen(favorites: favorites, name: name, make: make, model: model,   )));
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Find the perfect bike for your needs and enjoy a hassle-free rental experience.',
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
                    .where('category', isEqualTo: 'CategorySelection.Bike')
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
                        final automobileId = automobile.id;
                        final imageUrls =
                        List<String>.from(automobile['image_URL']);
                        name = automobile['automobile_name'] ?? '';
                        make = automobile['make'] ?? '';
                        model = automobile['model'] ?? '';
                        final carUnit = automobile['ac or non-ac'] ?? '';
                        final capacity = automobile['capacity'] ?? '';
                        final dailyPrice = automobile['daily_price'] ?? '';
                        final monthlyPrice = automobile['monthly_price'] ?? '';
                        final location = automobile['location'] ?? '';
                        final description = automobile['description'] ?? '';
                        final city = automobile['city'] ?? '';
                        final gears = automobile['no_of_gear'] ?? '';
                        final deviceToken = automobile['device_token'] ?? '';

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailsOfAutomobile(
                                  imageURL: imageUrls,
                                  automobileName: name,
                                  make: make,
                                  model: model,
                                  ac: carUnit,
                                  capacity: capacity,
                                  daily: dailyPrice,
                                  monthly: monthlyPrice,
                                  gears: gears,
                                  location: location,
                                  description: description,
                                  city: city,
                                  device_token: deviceToken,
                                ),
                              ),
                            );
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
                                    const Icon(
                                      Icons.attach_money,
                                      color: Colors.green,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Daily Price: $dailyPrice',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      onPressed: () =>
                                          toggleFavorite(automobileId),
                                      icon: Icon(
                                        isFavorite(automobileId)
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: Colors.red,
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        double rent = double.parse(dailyPrice);
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => Booking(automobileName: name, dailyRent: rent, make: make, model: model, deviceToken: deviceToken,)));
                                      },
                                      child: const Text('Book Now'),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                const Divider(
                                  color: Colors.blueGrey,
                                ),
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
                          'No bike found.',
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
                          onPressed: () {
                            setState(() {
                              const CircularProgressIndicator(
                                strokeWidth: 10,
                                color: Colors.black12,
                              );
                            });
                          },
                          icon: const Icon(
                            Icons.refresh,
                            color: Colors.blueGrey,
                          ),
                        ),
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
