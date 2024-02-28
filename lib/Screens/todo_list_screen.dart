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
          Observer(
            builder: (_) => Checkbox(
              value: todoStore.isSortAscending,
              onChanged: (value) {
                todoStore.sortTasksByCompletion();
              },
            ),
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
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: (value) {
                      todoStore.setSearchTerm(value);
                    },
                    decoration: const InputDecoration(
                      labelText: 'Search',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Expanded(
                  child: Observer(
                    builder: (_) {
                      final todosToShow = todoStore.searchResults.isNotEmpty ? todoStore.searchResults : todoStore.todos;
                      final bool noMatches = todoStore.searchResults.isEmpty && todoStore.searchTerm.isNotEmpty;

                      if (noMatches) {
                        return const Center(
                          child: Text('No todos available'),
                        );
                      } else {
                        return ListView.separated(
                          separatorBuilder: (context, index) => const Divider(
                            height: 10,
                            color: Colors.black,
                          ),
                          itemCount: todosToShow.length,
                          itemBuilder: (context, index) {
                            final todo = todosToShow[index];
                            return ListTile(
                              onTap: () => _editTodoDescription(
                                context,
                                index,
                                todo.title,
                                todo.description,
                              ),
                              title: Text(todo.title),
                              subtitle: Text(todo.description),
                              leading: Checkbox(
                                value: todo.completed,
                                onChanged: (value) {
                                  todoStore.toggleCompleted(index);
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
                  ),
                ),
              ],
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

  Future<void> _editTodoDescription(BuildContext context, int index, String currentTitle, String currentDescription) async {
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditDescriptionDialog(
          currentTitle: currentTitle,
          currentDescription: currentDescription,
        );
      },
    );

    if (result == 'delete') {
      _confirmDelete(context, index, todoStore);
    } else if (result != null && result is Map<String, String>) {
      final editedTodo = todoStore.searchResults.isNotEmpty
          ? todoStore.searchResults[index].copyWith(
        title: result['title'] ?? currentTitle,
        description: result['description'] ?? currentDescription,
      )
          : todoStore.todos[index].copyWith(
        title: result['title'] ?? currentTitle,
        description: result['description'] ?? currentDescription,
      );

      if (todoStore.searchResults.isNotEmpty) {
        todoStore.editTodo(
          todoStore.todos.indexOf(todoStore.searchResults[index]),
          editedTodo,
        );
      } else {
        todoStore.editTodo(index, editedTodo);
      }
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
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != null && confirmed) {
      final todo = todoStore.todos.firstWhere((todo) => todo.id == todoStore.searchResults[index].id);
      todoStore.deleteTodo(todo.id);
    }
  }
}