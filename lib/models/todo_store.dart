import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'todo_model.dart';

part 'todo_store.g.dart';

class TodoStore = _TodoStore with _$TodoStore;

abstract class _TodoStore with Store {
  @observable
  ObservableList<Todo> todos = ObservableList<Todo>();

  @observable
  bool isSortAscending = true;

  @action
  Future<void> fetchTodos() async {
    try {
      final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/todos'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        todos = data.map((item) => Todo.fromJson(item)).toList().asObservable();
      } else {
        throw Exception('Failed to load todos');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching todos: $e');
      }
    }
  }

  @action
  void addTodo(Todo todo) {
    todos.insert(0, todo);
  }

  @action
  void deleteTodo(int index) {
    todos.removeAt(index);
  }

  @action
  void editTodo(int index, Todo editedTodo) {
    todos[index] = editedTodo;
  }

  @action
  void toggleCompleted(int index) {
    todos[index].completed = !todos[index].completed;
  }

  @action
  void sortTasksByCompletion() {
    todos.sort((a, b) {
      if (a.completed && !b.completed) {
        return isSortAscending ? -1 : 1;
      } else if (!a.completed && b.completed) {
        return isSortAscending ? 1 : -1;
      } else {
        return 0;
      }
    });

    isSortAscending = !isSortAscending;
  }
}