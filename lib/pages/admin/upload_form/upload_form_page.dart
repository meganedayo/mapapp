import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mapapp/firestore/map_layout_data.dart';
import 'package:mapapp/pages/home/fetch_attractions.dart';
import 'package:uuid/uuid.dart';

import '../../home/fetch_attraction_image.dart';
import '../map_edit_step/image_file.dart';
import '../map_editor/attraction.dart';

// マップが無い場合がありえるけど一旦無視
// illustマップのみ対応

class UploadFormPage extends ConsumerStatefulWidget {
  const UploadFormPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UploadFormPageState();
}

class _UploadFormPageState extends ConsumerState<UploadFormPage> {
  var _currentStep = 0;
  final Map<String, List<ImageFile>> _pickedFiles = {};

  @override
  initState() {
    super.initState();
    final attractions = ref.read(fetchAttractionsProvider).value;

    if (attractions != null) {
      for (final attraction in attractions) {
        _pickedFiles[attraction.attractionId] = [];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final attractions = ref.watch(fetchAttractionsProvider).value;

    if (attractions == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (attractions.isEmpty) {
      return const Center(
        child: Text("アトラクションがありません"),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("アトラクションの画像を新しく追加する"),
      ),
      body: SingleChildScrollView(
        child: Stepper(
          currentStep: _currentStep,
          onStepContinue: () async {
            if (_currentStep == attractions.length) {
              final ctx = context;
              await _onCompleteAllStep();

              if (ctx.mounted) {
                Navigator.of(ctx).pop();
              }
              return;
            }

            setState(() {
              _currentStep += 1;
            });
          },
          onStepCancel: () {
            if (_currentStep == 0) return;

            setState(() {
              _currentStep -= 1;
            });
          },
          onStepTapped: (index) {
            if (_currentStep < index) return;

            setState(() {
              _currentStep = index;
            });
          },
          steps: [
            // 本来ならマップの種類を選択するステップが必要だが，今回は省略
            ...attractions
                .asMap()
                .entries
                .map((e) => _buildStep(context, e.key, e.value)),
            _buildFinalStep(context),
          ],
        ),
      ),
    );
  }

  Step _buildStep(BuildContext context, int i, Attraction attraction) {
    return Step(
      title: Text("${attraction.name} の画像を選択する"),
      isActive: _currentStep == 0,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: ElevatedButton.icon(
              onPressed: () async {
                final pickedImage = await ImagePicker().pickMultiImage();

                if (pickedImage.isEmpty) {
                  debugPrint("pickedImage is empty");
                  return;
                }

                final imageBytes =
                    await Future.wait(pickedImage.map((e) => e.readAsBytes()));
                final images = await Future.wait(imageBytes.map((e) async {
                  final image = await decodeImageFromList(e);
                  return Size(image.width.toDouble(), image.height.toDouble());
                }));

                setState(() {
                  _pickedFiles[attraction.attractionId] = pickedImage
                      .asMap()
                      .entries
                      .map((e) => (
                            file: e.value,
                            uint8list: imageBytes[e.key],
                            size: images[e.key],
                          ))
                      .toList();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              icon: const Icon(Icons.upload_file_rounded),
              label: Text("${attraction.name} の画像を選択"),
            ),
          ),
          Wrap(
            direction: Axis.horizontal,
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final file in _pickedFiles[attraction.attractionId] ?? [])
                SizedBox(
                  width: 150,
                  height: 150,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Image.memory(file.uint8list),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Step _buildFinalStep(BuildContext context) {
    return Step(
      title: const Text("完了"),
      content: Container(),
    );
  }

  Future<void> _onCompleteAllStep() async {
    for (final entry in _pickedFiles.entries) {
      final attractionId = entry.key;
      final files = entry.value;

      final storageRef = FirebaseStorage.instance.ref();
      final attractionsRef = storageRef.child("attractions/$attractionId");

      final db = FirebaseFirestore.instance;
      final illustrationsRef = db
          .collection("maps")
          .doc(illustMapId)
          .collection("attractions")
          .doc(attractionId)
          .collection("illustrations")
          .withConverter(
            fromFirestore: Illustration.fromFirestore,
            toFirestore: (illustration, _) => illustration.toFirestore(),
          );

      for (final file in files) {
        final imageRef = attractionsRef.child(const Uuid().v4());

        // storageに保存
        await imageRef.putData(
          file.uint8list,
          SettableMetadata(contentType: "image/jpeg"),
        );

        // 画像のURLを取得
        final imageUrl = await imageRef.getDownloadURL();

        // 画像のURLをfirestoreに保存
        await illustrationsRef.add(Illustration(imageUrl: imageUrl));
      }
    }
  }
}
