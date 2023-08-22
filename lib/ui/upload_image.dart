import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/firestore/add_firestore_data.dart';
import 'package:flutter_firebase/utils/utils.dart';
import 'package:flutter_firebase/widgets/round_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({super.key});

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  bool loading = false;
  File? _image;
  final picker = ImagePicker();
  DatabaseReference ref = FirebaseDatabase.instance.ref('post');
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future getGalleryImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image picked');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.deepPurple,
          title: const Text('Upload Image'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                getGalleryImage();
              },
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: _image != null
                    ? Image.file(_image!.absolute)
                    : const Center(
                        child: Icon(
                          Icons.image_outlined,
                        ),
                      ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: RoundButton(
                loading: loading,
                title: 'Upload',
                onTap: () async {
                  setState(() {
                    loading = true;
                  });
                  final id = DateTime.now().microsecondsSinceEpoch.toString();
                  firebase_storage.Reference ref =
                      firebase_storage.FirebaseStorage.instance.ref(
                    '/images/' + id,
                  );

                  firebase_storage.UploadTask uploadTask =
                      ref.putFile(_image!.absolute);
                  Future.value(uploadTask).then(
                    (value) async {
                      var newUrl = await ref.getDownloadURL();
                      databaseRef.child(id).set(
                          {'title': newUrl.toString(), 'id': id}).then((value) {
                        setState(() {
                          loading = false;
                        });
                        Utils().toastMessage('Uploaded');
                      }).onError((error, stackTrace) {
                        Utils().toastMessage(error.toString());
                        setState(() {
                          loading = false;
                        });
                      });
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
