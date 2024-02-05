import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../models/todo_model.dart';
import '../models/todo_store.dart';
import 'add_screen.dart';
import 'edit_screen.dart';

class TodoListScreen extends StatefulWidget {
  final TodoStore todoStore;

  const TodoListScreen({super.key, required this.todoStore});

  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  @override
  void initState() {
    super.initState();
    widget.todoStore.fetchTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MobX Todo App'),
        centerTitle: true,
      ),
      body: Observer(
        builder: (_) {
          return ListView.separated(
            separatorBuilder: (context, index) => const Divider(
              height: 10,
              color: Colors.black,
            ),
            itemCount: widget.todoStore.todos.length,
            itemBuilder: (context, index) {
              final todo = widget.todoStore.todos[index];
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
                          widget.todoStore.toggleCompleted(index);
                        });
                      },
                    );
                  },
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => widget.todoStore.deleteTodo(index),
                ),
              );
            },
          );
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
            widget.todoStore.addTodo(newTodo);
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
      final editedTodo = widget.todoStore.todos[index].copyWith(
        title: editedData['title'] ?? currentTitle,
        description: editedData['description'] ?? currentDescription,
      );

      widget.todoStore.editTodo(index, editedTodo);
    }
  }
}
