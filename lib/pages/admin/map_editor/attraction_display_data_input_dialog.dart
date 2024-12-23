import 'package:flutter/material.dart';

class AttractionDisplayDataInputDialog extends StatefulWidget {
  final Function(String, String) _onSubmitted;
  final Function() _onCanceled;

  const AttractionDisplayDataInputDialog(
      {super.key,
      required Function(String, String) onSubmitted,
      required Function() onCanceled})
      : _onSubmitted = onSubmitted,
        _onCanceled = onCanceled;

  @override
  State<AttractionDisplayDataInputDialog> createState() =>
      _AttractionDisplayDataInputDialogState();
}

class _AttractionDisplayDataInputDialogState
    extends State<AttractionDisplayDataInputDialog> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("新しいアトラクションを追加"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: "名前"),
            autofocus: true,
          ),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: "説明"),
            maxLines: 2,
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () => widget._onSubmitted(
            _nameController.text,
            _descriptionController.text,
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
          ),
          child: const Text("追加"),
        ),
        TextButton(
          onPressed: widget._onCanceled,
          child: const Text("キャンセル"),
        ),
      ],
    );
  }
}
