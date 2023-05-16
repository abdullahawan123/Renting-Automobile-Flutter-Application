import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as path;
import 'package:carousel_slider/carousel_slider.dart';

class BO_Details extends StatefulWidget {
  @override
  _BO_DetailsState createState() => _BO_DetailsState();
}

class _BO_DetailsState extends State<BO_Details> {
  List<File> _selectedImages = [];
  List<Widget> _imageWidgets = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _modelMakeController = TextEditingController();

  void successMessage(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('Automobile details uploaded successfully.'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _uploadData() async {
    // Validate form fields
    if (_selectedImages.isEmpty ||
        _nameController.text.isEmpty ||
        _categoryController.text.isEmpty ||
        _modelMakeController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Please fill in all fields and select at least one image.'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    try {
      List<String> imageUrls = [];

      // Upload images to Firebase Storage
      for (File imageFile in _selectedImages) {
        String imageName = path.basename(imageFile.path);
        Reference storageRef = FirebaseStorage.instance.ref().child(imageName);
        UploadTask uploadTask = storageRef.putFile(imageFile);
        TaskSnapshot storageSnapshot = await uploadTask.whenComplete(() => null);
        String imageUrl = await storageSnapshot.ref.getDownloadURL();
        imageUrls.add(imageUrl);
      }

      // Upload automobile details and image URLs to Firestore
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      CollectionReference automobilesRef = firestore.collection('automobiles');
      await automobilesRef.add({
        'image_urls': imageUrls,
        'name': _nameController.text,
        'category': _categoryController.text,
        'model_make': _modelMakeController.text,
      });

      // Show success dialog
      successMessage();

      // Clear form fields
      _selectedImages.clear();
      _nameController.clear();
      _categoryController.clear();
      _modelMakeController.clear();


    } catch (error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('An error occurred.'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();

    setState(() {
      _selectedImages = images.map((XFile image) => File(image.path)).toList();
      _imageWidgets = _selectedImages
          .map((File image) => Image.file(
        image,
        width: 150,
        height: 150,
        fit: BoxFit.cover,
      ))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Automobile Name'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _modelMakeController,
                decoration: const InputDecoration(labelText: 'Model Make'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _pickImages,
                child: const Text('Select Images'),
              ),
              const SizedBox(height: 10),
              CarouselSlider(
                options: CarouselOptions(
                  height: 200,
                  enableInfiniteScroll: false,
                ),
                items: _imageWidgets,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _uploadData,
                child: const Text('Upload'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}