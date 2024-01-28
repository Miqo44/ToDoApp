import 'package:flutter/material.dart';

import '../models/models.dart';

class TodoListScreen extends StatefulWidget {
  final ApiService apiService;

  const TodoListScreen({super.key, required this.apiService});

  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  late Future<List<Todo>> _tasksFuture;
  late String _newTaskTitle = ''; // Declare variable to capture entered title

  @override
  void initState() {
    super.initState();
    _tasksFuture = widget.apiService.getTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Todo>>(
        future: _tasksFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final tasks = snapshot.data!;
            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return ListTile(
                  title: Text(task.title),
                  leading: Checkbox(
                    value: task.completed,
                    onChanged: (value) {
                      setState(() {
                        task.setCompleted(value!);
                        widget.apiService.completeTask(task.id, value);
                      });
                    },
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      widget.apiService.deleteTask(task.id).then((_) {
                        setState(() {
                          tasks.removeAt(index);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Task deleted successfully.'),
                          ),
                        );
                      }).catchError((error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to delete task: $error'),
                          ),
                        );
                      });
                    },
                  ),
                  onLongPress: () async {
                    await _editTaskDialog(context, this, task);
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          _newTaskTitle = ''; // Reset the variable before showing the dialog
          final title = await showDialog<String>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('New Task'),
              content: TextField(
                onChanged: (value) {
                  _newTaskTitle = value; // Capture the entered title
                },
              ),
              actions: [
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.pop(context),
                ),
                TextButton(
                  child: const Text('Add'),
                  onPressed: () async {
                    // Create a new task with the captured title
                    await widget.apiService.createTask(_newTaskTitle).then((_) {
                      setState(() {
                        _tasksFuture = _tasksFuture.then((tasks) {
                          tasks.add(Todo(id: tasks.length + 1, title: _newTaskTitle, completed: false));
                          return tasks;
                        });
                        Navigator.pop(context, 'Task added');
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Task added successfully.'),
                        ),
                      );
                    }).catchError((error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to add task: $error'),
                        ),
                      );
                    });
                  },
                ),
              ],
            ),
          );
          if (title != null) {
            widget.apiService.createTask(title).then((_) {
              setState(() {
                _tasksFuture = widget.apiService.getTasks();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Task added successfully.'),
                ),
              );
            }).catchError((error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to add task: $error'),
                ),
              );
            });
          }
        },
      ),
    );
  }
  Future<void> _editTaskDialog(BuildContext context, _TodoListScreenState state, Todo task) async {
    String newTitle = task.title;
    bool newCompleted = task.completed;

    await showDialog<String>(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: const Text('Edit Task'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (value) {
                    newTitle = value;
                  },
                  controller: TextEditingController(text: task.title),
                ),
                Checkbox(
                  value: newCompleted,
                  onChanged: (value) {
                    newCompleted = value!;
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: const Text('Save'),
                onPressed: () async {
                  // Update the task with the new title and completion status
                  task.updateTask(newTitle, newCompleted);
                  await state.widget.apiService.updateTask(
                      task.id, newTitle, newCompleted);

                  state.setState(() {
                    // Refresh the UI
                    state._tasksFuture = state.widget.apiService.getTasks();
                    Navigator.pop(context, 'Task updated');
                  });
                },
              ),
            ],
          ),
    );
  }
}

