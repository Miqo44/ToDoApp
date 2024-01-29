import 'package:flutter/foundation.dart';
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
  late String _newTaskTitle = '';

  @override
  void initState() {
    super.initState();
    _tasksFuture = widget.apiService.getTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Todo List',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
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
                  subtitle: Text(task.description),
                  leading: Checkbox(
                    activeColor: Colors.blueAccent,
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
                    await _editTaskDialog(context, this, task,
                        (bool value, String description) {
                      setState(() {
                        task.setCompleted(value);
                        task.updateTask(task.title, value,
                            description);
                        widget.apiService.updateTask(
                            task.id, task.title, value, description);
                      });
                    });
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
          _newTaskTitle = '';
          final title = await showDialog<String>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('New Task'),
              content: TextField(
                onChanged: (value) {
                  _newTaskTitle = value;
                },
              ),
              actions: [
                TextButton(
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                TextButton(
                  child: const Text(
                    'Add',
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () async {
                    await widget.apiService.createTask(_newTaskTitle).then((_) {
                      setState(() {
                        _tasksFuture = _tasksFuture.then((tasks) {
                          tasks.insert(
                            0,
                            Todo(
                              id: tasks.length + 1,
                              title: _newTaskTitle,
                              description: "",
                              completed: false,
                            ),
                          );
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

  Future<void> _editTaskDialog(BuildContext context, _TodoListScreenState state,
      Todo task, Function(bool, String) onTaskUpdated) async {
    String newTitle = task.title;
    String newDescription = task.description;
    bool newCompleted = task.completed;

    await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
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
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              onChanged: (value) {
                newDescription = value;
              },
              controller: TextEditingController(text: task.description),
              decoration: const InputDecoration(labelText: 'Description'),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () async {
              try {
                task.updateTask(newTitle, newCompleted, newDescription);
                await state.widget.apiService.updateTask(
                    task.id, newTitle, newCompleted, newDescription);
                state.setState(() {
                  Navigator.pop(context, 'Task updated');
                });
              } catch (e) {
                if (kDebugMode) {
                  print('Error updating task: $e');
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
