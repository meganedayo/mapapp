import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../firestore/map_layout_data.dart';
import '../map_editor/attraction.dart';
import '../map_editor/map_editor_page.dart';
import 'image_file.dart';
import 'map_type.dart';

class MapEditStepPage extends StatefulWidget {
  const MapEditStepPage({super.key});

  @override
  State<MapEditStepPage> createState() => _MapEditStepPageState();
}

class _MapEditStepPageState extends State<MapEditStepPage> {
  var _currentStep = 0;
  MapType? _mapType = MapType.illust;
  ImageFile? _pickedFile;
  Map<String, Attraction>? _mapLayout;

  bool isUploading = false;

  StepState _stepState(
      int stepIndex, int currentStepIndex, bool isStepComplete) {
    // 現在のステップの場合
    if (currentStepIndex == stepIndex) {
      // 編集中のアイコン表示
      return StepState.editing;
    }
    // 完了済みのステップの場合
    if (isStepComplete) {
      // 完了のアイコン表示
      return StepState.complete;
    }
    // 未到達ステップの場合，タップ無効化
    return StepState.disabled;
  }

  Future<void> _onCompleteAllStep() async {
    final mapType = _mapType;
    final pickedFile = _pickedFile;
    final mapLayout = _mapLayout;

    // マップの種類，背景画像，アトラクションの配置が全て完了しているか
    if (mapType == null || pickedFile == null || mapLayout == null) {
      return;
    }

    setState(() {
      isUploading = true;
    });

    // マップの種類，背景画像，アトラクションの配置を保存する処理
    final mapLayoutData = MapLayoutData(
      type: mapType,
      mapImageFile: pickedFile,
      attractions: mapLayout,
    );

    // 画像アップロードとURL取得
    final storageRef = FirebaseStorage.instance.ref();
    final mapImageRef = storageRef.child("map_images/${mapLayoutData.id}");

    // 画像をアップロード
    await mapImageRef.putData(
      mapLayoutData.mapImageFile.uint8list,
      SettableMetadata(
        // 画像の形式を指定 いったんjpegで固定
        contentType: "image/jpeg",
      ),
    );

    // 画像のURLを取得
    final mapImageUrl = await mapImageRef.getDownloadURL();

    final db = FirebaseFirestore.instance;

    final mapRef = db.collection("maps").doc(mapLayoutData.id);

    // マップレイアウトを保存
    await mapRef.set({
      "id": mapLayoutData.id,
      "type": mapType.index,
      "mapImageUrl": mapImageUrl,
    });

    final attractionsRef = mapRef.collection("attractions").withConverter(
          fromFirestore: Attraction.fromFirestore,
          toFirestore: (attraction, options) => attraction.toFirestore(),
        );

    // マップの種類，背景画像，アトラクションの配置を保存
    for (final attraction in mapLayout.values) {
      await attractionsRef.doc(attraction.attractionId).set(attraction);
    }

    setState(() {
      isUploading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("マップ編集"),
      ),
      body: isUploading
          ? const Center(child: CircularProgressIndicator())
          : _buildStepper(context),
    );
  }

  Widget _buildStepper(BuildContext context) {
    return SingleChildScrollView(
      child: Stepper(
        currentStep: _currentStep,
        onStepContinue: () async {
          if (_currentStep == 3) {
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
          Step(
            title: const Text("マップの種類を選択する"),
            isActive: _currentStep == 0,
            content: _buildStep1Content(),
            state: _stepState(0, _currentStep, _mapType != null),
          ),
          Step(
            title: const Text("背景画像を登録する"),
            content: _buildStep2Content(context),
            isActive: _currentStep == 1,
            state: _stepState(1, _currentStep, _pickedFile != null),
          ),
          Step(
            title: const Text("アトラクションの配置を設定する"),
            content: _buildStep3Content(context),
            isActive: _currentStep == 2,
            state: _stepState(
                2, _currentStep, _mapLayout != null && _mapLayout!.isNotEmpty),
          ),
          Step(
            title: const Text("完了"),
            content: Container(),
            isActive: _currentStep == 3,
            state: _stepState(3, _currentStep, false),
          ),
        ],
      ),
    );
  }

  ListView _buildStep1Content() {
    return ListView(
      shrinkWrap: true,
      children: MapType.values
          .map(
            (type) => RadioListTile<MapType>(
              title: Text(type.name),
              value: type,
              groupValue: _mapType,
              onChanged: (value) {
                if (value == null) return;

                setState(() {
                  _mapType = value;
                });
              },
            ),
          )
          .toList(),
    );
  }

  Column _buildStep2Content(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: ElevatedButton.icon(
            onPressed: () async {
              final pickedImage =
                  await ImagePicker().pickImage(source: ImageSource.gallery);

              if (pickedImage == null) {
                debugPrint("pickedImage == null");
                return;
              }

              final imageBytes = await pickedImage.readAsBytes();
              final image = await decodeImageFromList(imageBytes);

              setState(() {
                _pickedFile = (
                  file: pickedImage,
                  uint8list: imageBytes,
                  size: Size(
                    image.width.toDouble(),
                    image.height.toDouble(),
                  ),
                );
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            icon: const Icon(Icons.upload_file_rounded),
            label: const Text("背景画像を選択"),
          ),
        ),
        if (_pickedFile != null)
          Flexible(
            child: SizedBox(
              width: 200,
              height: 200,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Image.memory(_pickedFile!.uint8list),
              ),
            ),
          ),
      ],
    );
  }

  Center _buildStep3Content(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton.icon(
            onPressed: () async => await _onMapEditorLaunched(context),
            icon: const Icon(Icons.map_rounded),
            label: const Text("アトラクションを配置する"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
          ),
          const SizedBox(height: 10),
          if (_mapLayout != null)
            Wrap(
              runSpacing: 10,
              alignment: WrapAlignment.center,
              spacing: 10,
              children: [
                for (final attraction in _mapLayout!.values)
                  Chip(
                    label: Text(attraction.name),
                  ),
              ],
            )
        ],
      ),
    );
  }

  Future<void> _onMapEditorLaunched(BuildContext context) async {
    final mapLayout = await Navigator.of(context).push<Map<String, Attraction>>(
          MaterialPageRoute(
            builder: (context) {
              return MapEditorPage(
                imageFile: _pickedFile!,
              );
            },
          ),
        ) ??
        {};

    setState(() {
      _mapLayout = mapLayout;
    });
  }
}
