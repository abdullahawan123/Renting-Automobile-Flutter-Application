import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:wheel_for_a_while/UI/utils/utilities.dart';

class BO_Details extends StatefulWidget {
  @override
  _BO_DetailsState createState() => _BO_DetailsState();
}

class _BO_DetailsState extends State<BO_Details> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _makeController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();
  final TextEditingController _gearsController = TextEditingController();
  final TextEditingController _acController = TextEditingController();
  final TextEditingController _dailyPriceController = TextEditingController();
  final TextEditingController _monthlyPriceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;


  final ImagePicker _picker = ImagePicker();
  final List<XFile> _selectedList = [];
  bool loading = false ;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Automobile Name', hintText: 'Honda, Suzuki, Hyundai', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _categoryController,
                  decoration: const InputDecoration(labelText: 'Category', hintText: 'Car, bike, SUV', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _modelController,
                        decoration: const InputDecoration(labelText: 'Model', hintText: '2017', border: OutlineInputBorder()),
                      ),
                    ),
                    const SizedBox(width: 5,),
                    Expanded(
                      child: TextField(
                        controller: _makeController,
                        decoration: const InputDecoration(labelText: 'Make', hintText: 'SONATA, CIVIC, CITY, etc', border: OutlineInputBorder()),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _capacityController,
                  decoration: const InputDecoration(labelText: 'Seating Capacity', hintText: '4,5', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _gearsController,
                        decoration: const InputDecoration(labelText: 'Automatic or Manual', border: OutlineInputBorder()),
                      ),
                    ),
                    const SizedBox(width: 5,),
                    Expanded(
                      child: TextField(
                        controller: _cityController,
                        decoration: const InputDecoration(labelText: 'City', border: OutlineInputBorder()),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _dailyPriceController,
                        decoration: const InputDecoration(labelText: 'Price', hintText: 'Daily', border: OutlineInputBorder()),
                      ),
                    ),
                    const SizedBox(width: 5,),
                    Expanded(
                      child: TextField(
                        controller: _monthlyPriceController,
                        decoration: const InputDecoration(labelText: 'Price', hintText: 'Monthly', border: OutlineInputBorder()),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _locationController,
                        decoration: const InputDecoration(labelText: 'Location', hintText: 'Place of the car', border: OutlineInputBorder()),
                      ),
                    ),
                    const SizedBox(width: 5,),
                    Expanded(
                      child: TextField(
                        controller: _acController,
                        decoration: const InputDecoration(
                          labelText: 'AC or Non-AC',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  maxLines: 4,
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description', hintText: 'Tell us about the car, a short summary!!!', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: selectImage,
                  child: const Text('Select Images'),
                ),
                const SizedBox(height: 10),
                _selectedList.isEmpty
                    ? const Text("No Image selected")
                    : GridView.builder(
                  shrinkWrap: true,
                  itemCount: _selectedList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Image.file(
                        File(_selectedList[index].path),
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if(_selectedList.isNotEmpty){
            if(_nameController.text.isEmpty ||
                _categoryController.text.isEmpty ||
                _modelController.text.isEmpty ||
                _capacityController.text.isEmpty ||
                _makeController.text.isEmpty ||
                _acController.text.isEmpty ||
                _dailyPriceController.text.isEmpty ||
                _monthlyPriceController.text.isEmpty ||
                _descriptionController.text.isEmpty ||
                _locationController.text.isEmpty ||
                _cityController.text.isEmpty
            ){
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Error'),
                    content: const Text('Please fill in all fields'),
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
            else{
              setState(() {
                loading = true ;
              });
              uploadFunction(_selectedList);
            }

          }else{
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please Select at least one image?')));
          }
          
        },
        tooltip: 'Upload',
        child: loading
            ? const CircularProgressIndicator(strokeWidth: 4, color: Color(0xFF03DAC6),)
            : const Icon(Icons.file_upload),
      ),
    );
  }

  void uploadFunction(List<XFile> images) async {
    List<String> imageUrls = [];
    for (int i = 0; i < images.length; i++) {
      String imageUrl = await uploadFile(images[i]);
      if (imageUrl.isNotEmpty) {
        imageUrls.add(imageUrl);
      }
    }
    if (imageUrls.isNotEmpty) {
      saveDataToFirestore(imageUrls);
    }
  }

  Future<String> uploadFile(XFile image) async {
    firebase_storage.Reference reference =
    firebase_storage.FirebaseStorage.instance.ref('/automobiles_images/'+DateTime.now().millisecondsSinceEpoch.toString());
    firebase_storage.UploadTask uploadTask = reference.putFile(File(image.path));

    try {
      await uploadTask;
      String downloadUrl = await reference.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      Utils().toastMessage("Error While Uploading ${e.toString()}");
      return e.toString();
    }
  }

  void saveDataToFirestore(List<String> imageUrls) {
    var user = _auth.currentUser;
    Map<String, dynamic> data = {
      'user_id' : user?.uid,
      'automobile_name': _nameController.text,
      'category': _categoryController.text,
      'model': _modelController.text,
      'make': _makeController.text,
      'capacity': _capacityController.text,
      'no_of_gear': _gearsController.text,
      'ac or non-ac': _acController.text,
      'description' : _descriptionController.text,
      'location' : _locationController.text,
      'city' : _cityController.text,
      'daily_price': _dailyPriceController.text,
      'monthly_price': _monthlyPriceController.text,
      'image_URL': imageUrls,

    };

    var id = "${DateTime.now().millisecondsSinceEpoch}";

    FirebaseFirestore.instance
        .collection('automobile')
        .doc(id)
        .set(data)
        .then((_) {
          setState(() {
            loading = false ;
          });
          Navigator.pop(context);
    }).catchError((error) {
      setState(() {
        loading = false;
      });
      Utils().toastMessage("Error While Uploading ${error.toString()}");
    });
  }

  Future<void> selectImage() async {
    _selectedList.clear();
    try {
      final List<XFile> imgs = await _picker.pickMultiImage();
      if (imgs.isNotEmpty) {
        _selectedList.addAll(imgs);
      }
    } catch (e) {
      Utils().toastMessage(e.toString());
    }
    setState(() {});
  }

  // Widget isUploading() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.center,
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       Center(child: Text("Uploading: $uploadItem/${_selectedList.length}")),
  //       const SizedBox(height: 10,),
  //       const Center(child: CircularProgressIndicator(strokeWidth: 4, color: Color(0xFF03DAC6),))
  //     ],
  //   );
  // }
}