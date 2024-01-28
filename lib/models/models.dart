import 'dart:convert';
import 'package:http/http.dart' as http;


class Todo {
  final int id;
  String title;
  bool completed;  // Make 'completed' non-final

  Todo({
    required this.id,
    required this.title,
    required this.completed,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      title: json['title'],
      completed: json['completed'],
    );
  }

  // Add this method to set the completion status
  void setCompleted(bool value) {
    completed = value;
  }

  void updateTask(String newTitle, bool newCompleted) {
    title = newTitle;
    completed = newCompleted;
  }
}

class ApiService {
  final String apiUrl = 'https://jsonplaceholder.typicode.com/todos';

  Future<List<Todo>> getTasks() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Todo.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  Future<void> createTask(String title) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      body: jsonEncode({'title': title, 'completed': false}),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create task');
    }
  }

  Future<void> deleteTask(int id) async {
    final response = await http.delete(Uri.parse('$apiUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete task');
    }
  }

  Future<void> completeTask(int id, bool completed) async {
    final response = await http.put(
      Uri.parse('$apiUrl/$id'),
      body: jsonEncode({'completed': completed}),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to complete task');
    }
  }

  Future<void> updateTask(int id, String newTitle, bool newCompleted) async {
    final response = await http.put(
      Uri.parse('$apiUrl/$id'),
      body: jsonEncode({'title': newTitle, 'completed': newCompleted}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update task');
    }
  }
}