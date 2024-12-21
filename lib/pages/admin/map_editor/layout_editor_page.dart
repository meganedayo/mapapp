import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

enum MapType {
  illust("イラストマップ"),
  detail("探索マップ");

  const MapType(this.name);

  final String name;
}

class MapEditorPage extends StatefulWidget {
  const MapEditorPage({super.key});

  @override
  State<MapEditorPage> createState() => _MapEditorPageState();
}

class _MapEditorPageState extends State<MapEditorPage> {
  var _currentStep = 0;
  MapType? _mapType = MapType.illust;
  ({XFile? file, Uint8List? uint8list}) pickedFile =
      (file: null, uint8list: null);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("マップ編集"),
      ),
      body: SingleChildScrollView(
        child: Stepper(
          currentStep: _currentStep,
          onStepContinue: () {
            if (_currentStep == 3) return;

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
              state: _stepState(1, _currentStep, pickedFile.uint8list != null),
            ),
            Step(
              title: const Text("アトラクションの配置を設定する"),
              content: Container(),
              isActive: _currentStep == 2,
              state: _stepState(2, _currentStep, false),
            ),
            Step(
              title: const Text("完了"),
              content: Container(),
              isActive: _currentStep == 3,
              state: _stepState(3, _currentStep, false),
            ),
          ],
        ),
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

              Uint8List imageBytes = await pickedImage.readAsBytes();

              setState(() {
                pickedFile = (file: pickedImage, uint8list: imageBytes);
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
        if (pickedFile.uint8list != null)
          Flexible(
            child: SizedBox(
              width: 200,
              height: 200,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Image.memory(pickedFile.uint8list!),
              ),
            ),
          ),
      ],
    );
  }
}
