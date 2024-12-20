import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  ({XFile? file, Uint8List? uint8list}) pickedFile =
      (file: null, uint8list: null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('イラストアップデート'),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            //名前入力
            const TextField(
              decoration: InputDecoration(
                hintText: ' 名前を入力してください',
              ),
            ),

            //画像アップロード
            ListTile(
              title: const Text('アップロード'),
              onTap: () async {
                final pickedImage =
                    await ImagePicker().pickImage(source: ImageSource.gallery);

                if (pickedImage == null) {
                  debugPrint("pickedImage == null");
                  return;
                }

                Uint8List imageBytes = await pickedImage.readAsBytes();

                setState(() {
                  pickedFile = (file: pickedImage, uint8list: imageBytes);
                });
              },
            ),

            if (pickedFile.uint8list != null)
              SizedBox(
                width: 200,
                height: 200,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Image.memory(pickedFile.uint8list!),
                ),
              ),

            //送信ボタン
            ElevatedButton(
              child: const Text('送信'),
              onPressed: () async {
                final storageRef = FirebaseStorage.instance.ref();
                final mountainsRef = storageRef.child("mountains.jpg");

                final uint8image = pickedFile.uint8list;

                if (uint8image == null) {
                  debugPrint("画像が選択されていないときに送信ボタンを押した");
                  return;
                }

                // Uint8Listを画像としてアップロードしたい
                final task = await mountainsRef.putData(uint8image);
              },
            ),
          ],
        ),
      ),
    );
  }
}
