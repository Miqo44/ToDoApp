import 'package:flutter/material.dart';
import '../models/todo_model.dart';

class AddTodoDialog extends StatefulWidget {
  const AddTodoDialog({super.key});

  @override
  _AddTodoDialogState createState() => _AddTodoDialogState();
}

class _AddTodoDialogState extends State<AddTodoDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Todo'),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(labelText: 'Todo'),
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
            final newTodo = Todo(
              id: DateTime.now().millisecondsSinceEpoch,
              description: '',
              title: _controller.text,
              completed: false,
            );
            Navigator.of(context).pop(newTodo);
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}