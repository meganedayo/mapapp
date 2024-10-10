import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  File? image;
  final picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('イラストアップデート'),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            //名前入力
            TextField(
              decoration: InputDecoration(
                hintText: ' 名前を入力してください',
              ),
            ),

            //画像アップロード
            ListTile(
              title: Text('アップロード'),
              onTap: () async {
                final XFile? _image =
                    await picker.pickImage(source: ImageSource.gallery);
                setState(() {
                  if (_image != null) {
                    image = File(_image.path);
                  }
                });
              },
            ),
            image == null
                ? const Text('画像がありません')
                : Image.file(image!, fit: BoxFit.cover),

            //送信ボタン
            ElevatedButton(
              onPressed: () {},
              child: Text('送信'),
            ),
          ],
        ),
      ),
    );
  }
}
