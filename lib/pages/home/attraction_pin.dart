import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapapp/pages/home/fetch_attraction_image.dart';

import '../admin/map_editor/map_editor_page.dart';

class AttractionPin extends ConsumerWidget {
  final AttractionDisplayData attraction;

  const AttractionPin({super.key, required this.attraction});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageUrl = ref.watch(fetchAttractionImageProvider(attraction.id));

    if (imageUrl.value == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (imageUrl.value!.isEmpty) {
      return const Center(
        child: Text("画像がありません"),
      );
    }

    return GestureDetector(
      onTap: () {
        messagePin(
            context: context,
            message: attraction.name,
            explan: attraction.description,
            realImagePath: imageUrl.value!);
      },
      child: Image.network(
        imageUrl.value!,
        fit: BoxFit.contain,
      ),
    );
  }

  void messagePin({
    required BuildContext context,
    required String message,
    required String explan,
    required String realImagePath,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 500,
          width: double.infinity,
          color: const Color.fromARGB(255, 97, 148, 98),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 200.0,
                  width: double.infinity,
                  child: Image.network(realImagePath),
                ),
                const ListTile(
                  leading: Icon(Icons.flutter_dash),
                  title: Text("遊具説明"),
                ),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.normal,
                    letterSpacing: 4.0,
                  ),
                ),
                Text(
                  explan,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.normal,
                    letterSpacing: 4.0,
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.info_outline_rounded),
                  title: const Text("イラスト切替"),
                  onTap: () {}, //一旦ステイ！！！！！！！！！
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
