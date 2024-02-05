import 'package:flutter/material.dart';

class EditDescriptionDialog extends StatefulWidget {
  final String currentTitle;
  final String currentDescription;

  const EditDescriptionDialog({
    super.key,
    required this.currentTitle,
    required this.currentDescription,
  });

  @override
  _EditDescriptionDialogState createState() => _EditDescriptionDialogState();
}

class _EditDescriptionDialogState extends State<EditDescriptionDialog> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.currentTitle);
    _descriptionController =
        TextEditingController(text: widget.currentDescription);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Task'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: 'Description'),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop({
              'title': _titleController.text,
              'description': _descriptionController.text,
            });
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}