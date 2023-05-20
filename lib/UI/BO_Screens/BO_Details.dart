import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
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

  final ImagePicker _picker = ImagePicker();
  final List<XFile> _selectedList = [];
  final FirebaseStorage _storageRef = FirebaseStorage.instance;
  List<String> arrImgUrl = [];
  int uploadItem = 0;
  bool _isUploading = false;

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
            child: _isUploading? isUploading() :Column(
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
                TextField(
                  controller: _gearsController,
                  decoration: const InputDecoration(labelText: 'Automatic or Manual', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),

                const SizedBox(height: 10),
                TextField(
                  controller: _acController,
                  decoration: const InputDecoration(
                    labelText: 'AC or Non-AC',
                    border: OutlineInputBorder(),
                  ),
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
            uploadFunction(_selectedList);  
          }else{
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please Select Image First??')));
          }
          
        },
        tooltip: 'Upload',
        child: const Icon(Icons.file_upload),
      ),
    );
  }

  void uploadFunction(List<XFile> images){
    setState(() {
      _isUploading = true;
    });
    for(int i = 0; i < images.length; i++){
      var imageUrl = uploadFile(images[i]);
      arrImgUrl.add(imageUrl.toString());
    }
  }

  Future<String> uploadFile(XFile image)async{
    Reference reference = _storageRef.ref().child('multiple_images').child(image.name);
    UploadTask uploadTask = reference.putFile(File(image.path));
    await uploadTask.whenComplete(() {
      setState(() {
        uploadItem++;
        if(uploadItem == _selectedList.length){
          _isUploading = false;
          uploadItem = 0;
        }
      });
    });
    return reference.getDownloadURL();
  }

  Future<void> selectImage()async{
    _selectedList.clear();
    try{
      final List<XFile> imgs = await _picker.pickMultiImage();
      if(imgs.isNotEmpty){
        _selectedList.addAll(imgs);
      }
    }catch(e){
      Utils().toastMessage(e.toString());
    }
    setState(() {});
  }

  Widget isUploading() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Uploading: $uploadItem/${_selectedList.length}"),
          const SizedBox(height: 10,),
          const CircularProgressIndicator(strokeWidth: 4, color: Color(0xFF03DAC6),)
        ],
      ),
    );
  }
}