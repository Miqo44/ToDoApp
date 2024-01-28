import 'package:flutter/material.dart';
import 'package:todoapp/screens/homeScreen.dart';
import 'models/models.dart';

void main() {
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  final ApiService apiService = ApiService();

  TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TodoListScreen(apiService: apiService),
    );
  }
}
