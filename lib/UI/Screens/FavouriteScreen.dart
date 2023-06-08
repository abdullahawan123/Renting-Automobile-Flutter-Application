import 'package:flutter/material.dart';
import 'package:wheel_for_a_while/UI/Widgets/hexStringToColor.dart';

class FavoritesScreen extends StatefulWidget {
  final List<String> favorites;
  final String name;
  final String make;
  final String model;

  const FavoritesScreen({
    Key? key,
    required this.favorites,
    required this.name,
    required this.model,
    required this.make,
  }) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  void toggleFavorite(String automobileId) {
    setState(() {
      if (widget.favorites.contains(automobileId)) {
        widget.favorites.remove(automobileId);
      } else {
        widget.favorites.add(automobileId);
      }
    });
  }

  bool isFavorite(String automobileId) {
    return widget.favorites.contains(automobileId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: const Text("Favorites"),
        centerTitle: true,
        automaticallyImplyLeading: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                hexStringToColor("03DAC6"),
                hexStringToColor("03DAC6"),
                hexStringToColor("1C201D"),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
        ),
      ),
      body: widget.favorites.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.favorite_border,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'Favourite any automobile, which you desire',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      )
          : ListView.builder(
        itemCount: widget.favorites.length,
        itemBuilder: (context, index) {
          final automobileId = widget.favorites[index];
          return ListTile(
            title: Text(widget.name),
            subtitle: Text('Make: ${widget.make} Model: ${widget.model}'),
            trailing: IconButton(
              onPressed: () => toggleFavorite(automobileId),
              icon: Icon(
                isFavorite(automobileId)
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: Colors.red,
              ),
            ),
          );
        },
      ),
    );
  }
}
