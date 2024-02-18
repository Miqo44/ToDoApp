import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../models/todo_model.dart';
import '../models/todo_store.dart';
import 'add_screen.dart';
import 'edit_screen.dart';

class TodoListScreen extends StatelessWidget {
  final TodoStore todoStore;

  const TodoListScreen({super.key, required this.todoStore});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MobX Todo App'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              todoStore.sortTasksByCompletion();
            },
          ),
        ],
      ),
      body: FutureBuilder<void>(
        future: todoStore.fetchTodos(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return Observer(
              builder: (_) {
                if (todoStore.todos.isEmpty) {
                  return const Center(
                    child: Text('No todos available'),
                  );
                } else {
                  return ListView.separated(
                    separatorBuilder: (context, index) => const Divider(
                      height: 10,
                      color: Colors.black,
                    ),
                    itemCount: todoStore.todos.length,
                    itemBuilder: (context, index) {
                      final todo = todoStore.todos[index];
                      return ListTile(
                        onTap: () => _editTodoDescription(
                          context,
                          index,
                          todo.title,
                          todo.description,
                        ),
                        title: Text(todo.title),
                        subtitle: Text(todo.description),
                        leading: StatefulBuilder(
                          builder: (context, setState) {
                            return Checkbox(
                              value: todo.completed,
                              onChanged: (_) {
                                setState(() {
                                  todoStore.toggleCompleted(index);
                                });
                              },
                            );
                          },
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _confirmDelete(context, index, todoStore),
                        ),
                      );
                    },
                  );
                }
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTodo = await showDialog<Todo>(
            context: context,
            builder: (BuildContext context) {
              return const AddTodoDialog();
            },
          );

          if (newTodo != null) {
            todoStore.addTodo(newTodo);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _editTodoDescription(BuildContext context, int index,
      String currentTitle, String currentDescription) async {
    final editedData = await showDialog<Map<String, String>>(
      context: context,
      builder: (BuildContext context) {
        return EditDescriptionDialog(
          currentTitle: currentTitle,
          currentDescription: currentDescription,
        );
      },
    );

    if (editedData != null) {
      final editedTodo = todoStore.todos[index].copyWith(
        title: editedData['title'] ?? currentTitle,
        description: editedData['description'] ?? currentDescription,
      );

      todoStore.editTodo(index, editedTodo);
    }
  }

  Future<void> _confirmDelete(BuildContext context, int index, TodoStore todoStore) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this todo?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Not confirmed
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Confirmed
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != null && confirmed) {
      todoStore.deleteTodo(index);
    }
  }
}
