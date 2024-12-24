import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
  ImageFile? pickedFile;
  Map<String, Attraction>? mapLayout;

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
              state: _stepState(1, _currentStep, pickedFile != null),
            ),
            Step(
              title: const Text("アトラクションの配置を設定する"),
              content: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () async =>
                          await _onMapEditorLaunched(context),
                      icon: const Icon(Icons.map_rounded),
                      label: const Text("アトラクションを配置する"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (mapLayout != null)
                      Wrap(
                        runSpacing: 10,
                        alignment: WrapAlignment.center,
                        spacing: 10,
                        children: [
                          for (final attraction in mapLayout!.values)
                            Chip(
                              label: Text(attraction.name),
                            ),
                        ],
                      )
                  ],
                ),
              ),
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

              final imageBytes = await pickedImage.readAsBytes();
              final image = await decodeImageFromList(imageBytes);

              setState(() {
                pickedFile = (
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
        if (pickedFile != null)
          Flexible(
            child: SizedBox(
              width: 200,
              height: 200,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Image.memory(pickedFile!.uint8list),
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _onMapEditorLaunched(BuildContext context) async {
    final mapLayout = await Navigator.of(context).push<Map<String, Attraction>>(
          MaterialPageRoute(
            builder: (context) {
              return MapEditorPage(
                imageFile: pickedFile!,
              );
            },
          ),
        ) ??
        {};

    setState(() {
      this.mapLayout = mapLayout;
    });
  }
}
