import 'package:flutter/material.dart';

const maxNameLength = 20;
const maxDescriptionLength = 100;

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
  final _formKey = GlobalKey<FormState>();

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
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "名前"),
              autofocus: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "名前を入力してください";
                }

                if (value.length > maxNameLength) {
                  return "名前は $maxNameLength 文字以内で入力してください";
                }

                return null;
              },
              onFieldSubmitted: (value) {
                _formKey.currentState?.validate();
              },
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: "説明"),
              maxLines: 2,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "説明を入力してください";
                }

                if (value.length > maxDescriptionLength) {
                  return "説明は $maxDescriptionLength 文字以内で入力してください";
                }

                return null;
              },
              onFieldSubmitted: (value) {
                _formKey.currentState?.validate();
              },
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;

            widget._onSubmitted(
              _nameController.text,
              _descriptionController.text,
            );
          },
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
