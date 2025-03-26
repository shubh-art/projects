import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task2103/task_detailed_screen.dart';
import 'package:task2103/task_services.dart';
import 'package:task2103/theme_provider.dart';

class TaskScreen extends StatelessWidget {
  const TaskScreen({super.key});

  void _showAddTaskDialog(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController detailsController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add New Task"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: "Title"),
              ),
              TextField(
                controller: detailsController,
                decoration:
                    const InputDecoration(labelText: "Details (Optional)"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  Provider.of<TaskProvider>(context, listen: false)
                      .addTask(titleController.text, detailsController.text);
                  Navigator.pop(context);
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDo List'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton.filledTonal(
              tooltip: themeMode.themeMode == ThemeMode.light
                  ? 'Tap to Enable Dark Mode'
                  : 'Tap to Disable Dark Mode',
              onPressed: () => themeMode.toggleTheme(),
              icon: themeMode.themeMode == ThemeMode.light
                  ? const Icon(Icons.light_mode)
                  : const Icon(Icons.dark_mode)),
        ],
      ),
      body: FutureBuilder(
          future: Provider.of<TaskProvider>(context, listen: false).init(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return Consumer<TaskProvider>(
                builder: (context, provider, child) {
                  return ListView.builder(
                      itemCount: provider.Tasks.length,
                      itemBuilder: (context, index) {
                        final task = provider.Tasks[index];
                        return InkWell(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      TaskDetailed(index: index))),
                          child: Hero(
                            tag: 'task_$index',
                            child: Card(
                              color: provider.Tasks[index].isCompleted
                                  ? Colors.blueGrey
                                  : null,
                              margin: const EdgeInsets.all(8),
                              elevation: 4,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  title: Text('${task.title}'),
                                  subtitle: Text('${task.details}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis),
                                  trailing: IconButton.outlined(
                                      onPressed: () => provider.delete(index),
                                      icon: const Icon(Icons.delete)),
                                  leading: Checkbox(
                                    onChanged: (value) {
                                      provider.taskCompleted(index);
                                    },
                                    value: provider.Tasks[index].isCompleted,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                },
              );
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
