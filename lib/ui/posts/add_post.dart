import 'package:flutter/material.dart';
import 'package:flutter_firebase/utils/utils.dart';
import 'package:flutter_firebase/widgets/round_button.dart';
import 'package:firebase_database/firebase_database.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

final databaseRef = FirebaseDatabase.instance.ref('Post');
bool loading = false;
final postController = TextEditingController();

class _AddPostScreenState extends State<AddPostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add post'),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              controller: postController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'What is in your mind?',
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.deepPurple,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.deepPurple,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.deepPurple,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.deepPurple,
                  ),
                  borderRadius: BorderRadius.circular(20),
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
              title: 'Add',
              onTap: () {
                setState(() {
                  loading = true;
                });
                databaseRef
                    .child(DateTime.now().millisecondsSinceEpoch.toString())
                    .set({
                  'id': DateTime.now().millisecondsSinceEpoch.toString(),
                  'title': postController.toString()
                }).then((value) {
                  setState(() {
                    loading = false;
                  });
                  Utils().toastMessage('Post added');
                }).onError((error, stackTrace) {
                  Utils().toastMessage(error.toString());
                  setState(() {
                    loading = false;
                  });
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
