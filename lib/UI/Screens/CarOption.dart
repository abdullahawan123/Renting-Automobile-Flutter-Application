
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wheel_for_a_while/UI/Screens/Booking.dart';
import 'package:wheel_for_a_while/UI/Screens/DetailsOfAutomobile.dart';
import 'package:wheel_for_a_while/UI/Screens/FavouriteScreen.dart';

class CarOption extends StatefulWidget {
  const CarOption({Key? key}) : super(key: key);

  @override
  _CarOptionState createState() => _CarOptionState();
}

class _CarOptionState extends State<CarOption> {
  List<String> favorites = [];
  String name = '';
  String make = '';
  String model = '';
  String businessUserID = '' ;

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

  String searchQuery = '';
  String selectedLocation = 'All';
  String selectedArea = 'All';

  List<String> locations = ['All'];
  List<String> areas = ['All', 'Area 1', 'Area 2', 'Area 3'];

  @override
  void initState() {
    super.initState();
    fetchLocations();
  }

  Future<void> fetchLocations() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('automobile')
        .where('category', isEqualTo: 'CategorySelection.Car')
        .get();

    final uniqueArea = <String>{'All'};
    final uniqueCity = <String>{'All'}; // Initialize with 'All'
    for (var doc in snapshot.docs) {
      final location = doc['city'] as String;
      uniqueCity.add(location);
    }
    for (var doc in snapshot.docs) {
      final area = doc['location'] as String;
      uniqueArea.add(area);
    }

    setState(() {
      locations = uniqueCity.toList();
      areas = uniqueArea.toList();
    });
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
                      Navigator.pop(context);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.favorite_border_outlined),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FavoritesScreen(
                            favorites: favorites,
                            name: name,
                            make: make,
                            model: model,
                          ),
                        ),
                      );
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search for cars',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        searchQuery = '';
                        selectedLocation = 'All';
                        selectedArea = 'All';
                      });
                    },
                    child: const Text('All'),
                  ),
                  DropdownButton<String>(
                    value: selectedLocation,
                    onChanged: (newValue) {
                      setState(() {
                        selectedLocation = newValue!;
                      });
                    },
                    items: locations.map<DropdownMenuItem<String>>(
                          (String location) {
                        return DropdownMenuItem<String>(
                          value: location,
                          child: Text(location),
                        );
                      },
                    ).toList(),
                  ),
                  DropdownButton<String>(
                    value: selectedArea,
                    onChanged: (newValue) {
                      setState(() {
                        selectedArea = newValue!;
                      });
                    },
                    items: areas.map<DropdownMenuItem<String>>(
                          (String area) {
                        return DropdownMenuItem<String>(
                          value: area,
                          child: Text(area),
                        );
                      },
                    ).toList(),
                  ),
                ],
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
                    final filteredAutomobiles = snapshot.data!.docs.where((automobile) {
                      final locationMatch = selectedLocation == 'All' || automobile['city'] == selectedLocation;
                      final areaMatch = selectedArea == 'All' || automobile['location'] == selectedArea;
                      final searchMatch = searchQuery.isEmpty || automobile['automobile_name'].toLowerCase().contains(searchQuery.toLowerCase());
                      return locationMatch && areaMatch && searchMatch;
                    }).toList();

                    if (filteredAutomobiles.isEmpty) {
                      return const Center(
                        child: Text(
                          'No cars found based on the selected filters.',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      );
                    }

                    return ListView(
                      padding: const EdgeInsets.all(16),
                      children: filteredAutomobiles.map((automobile) {
                        final automobileId = automobile.id;
                        final imageUrls = List<String>.from(automobile['image_URL']);
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
                        businessUserID = automobile['user_id'];

                        // Apply filters
                        if (searchQuery.isNotEmpty &&
                            !name.toLowerCase().contains(searchQuery.toLowerCase())) {
                          return Container();
                        }
                        if (selectedLocation == 'All' && location == selectedLocation) {
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
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => Booking(automobileName: name, dailyRent: rent,make: make, model: model, deviceToken: deviceToken,)));
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
                        }
                        if (selectedArea != 'All' && city == selectedArea) {
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
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => Booking(automobileName: name, dailyRent: rent,make: make, model: model, deviceToken: deviceToken,)));
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
                        }
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
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => Booking(automobileName: name, dailyRent: rent,make: make, model: model, deviceToken: deviceToken,)));
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
                  }else{
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
                  }


                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
