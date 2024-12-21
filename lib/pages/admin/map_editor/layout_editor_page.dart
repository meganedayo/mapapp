import 'package:flutter/material.dart';

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
              content: ListView(
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
              ),
              state: _stepState(0, _currentStep, _mapType != null),
            ),
            Step(
              title: const Text("画像を登録する"),
              content: Container(),
              isActive: _currentStep == 1,
              state: _stepState(1, _currentStep, false),
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
}
