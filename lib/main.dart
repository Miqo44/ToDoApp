import 'package:flutter/material.dart';
import 'Screens/todo_list_screen.dart';
import 'models/todo_store.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final TodoStore todoStore = TodoStore();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MobX Todo App',
      home: TodoListScreen(todoStore: todoStore),
    );
  }
}