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

  @observable
  bool showCompletedTasks = true;

  @observable
  String searchTerm = '';

  @observable
  ObservableList<Todo> searchResults = ObservableList<Todo>();

  @action
  Future<void> fetchTodos() async {
    try {
      final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/todos'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        todos = data.map((item) => Todo.fromJson(item)).toList().asObservable();
        filterTodos();
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
    filterTodos();
  }

  @action
  void deleteTodo(int id) {
    todos.removeWhere((todo) => todo.id == id);

    if (searchResults.isNotEmpty) {
      searchResults.removeWhere((searchedTodo) => searchedTodo.id == id);
    }
    filterTodos();
  }


  @action
  void editTodo(int index, Todo editedTodo) {
    todos[index] = editedTodo;
    filterTodos();
  }

  @action
  void toggleCompleted(int index) {
    if (searchResults.isNotEmpty) {
      final todoIndex = todos.indexOf(searchResults[index]);
      todos[todoIndex].completed = !todos[todoIndex].completed;
    } else {
      todos[index].completed = !todos[index].completed;
    }
    filterTodos();
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
    filterTodos();
  }

  @action
  void setSearchTerm(String term) {
    searchTerm = term;
    filterTodos();
  }

  void filterTodos() {
    if (searchTerm.isEmpty) {
      if (showCompletedTasks) {
        searchResults = todos.asObservable();
      } else {
        searchResults = todos.where((todo) => !todo.completed).toList().asObservable();
      }
    } else {
      final regex = RegExp(searchTerm, caseSensitive: false);
      if (showCompletedTasks) {
        searchResults = todos.where((todo) => regex.hasMatch(todo.title)).toList().asObservable();
      } else {
        searchResults = todos.where((todo) => !todo.completed && regex.hasMatch(todo.title)).toList().asObservable();
      }
    }
  }

  @action
  void toggle(bool value) {
    value = !value;
    filterTodos();
  }
}
