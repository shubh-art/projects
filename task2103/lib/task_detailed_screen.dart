import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task2103/task_services.dart';

class TaskDetailed extends StatelessWidget {
  const TaskDetailed({Key? key, required this.index});
  final int index;

  void _editWindow(BuildContext context, String title, String? details) {
    final TextEditingController titleController =
        TextEditingController(text: title);
    final TextEditingController detailsController =
        TextEditingController(text: details);
    final ScrollController _scrollController = ScrollController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Task"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: "Title"),
                ),
                TextField(
                  controller: detailsController,
                  maxLines: 5,
                  scrollController: _scrollController,
                  decoration:
                      const InputDecoration(labelText: "Details (Optional)"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  Provider.of<TaskProvider>(context, listen: false).edit(
                      index: index,
                      title: titleController.text,
                      details: detailsController.text);
                  Navigator.pop(context);
                }
              },
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final task = Provider.of<TaskProvider>(context).Tasks[index];
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton.outlined(
              onPressed: () {
                Provider.of<TaskProvider>(context).delete(index);
                Navigator.pop(context);
              },
              icon: const Icon(Icons.delete)),
        ],
      ),
      body: Hero(
        tag: 'task_$index',
        child: Material(
          child: SingleChildScrollView(
            child: Container(
              alignment: Alignment.center,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      '${task.title}',
                      style: const TextStyle(fontSize: 30),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        '${task.details ?? ''}',
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ]),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _editWindow(context, task.title, task.details),
        child: Icon(Icons.edit),
      ),
    );
  }
}
