import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:task2103/task_model.dart';

class TaskProvider extends ChangeNotifier {
  Box<Task>? _taskBox;
  List<Task> _todos = [];

  List<Task> get Tasks => _taskBox?.values.toList() ?? [];

  TaskProvider() {
    _initilize();
  }

  void _initilize() async {
    await init();
  }

  Future<void> init() async {
    _taskBox = await Hive.openBox<Task>('tasks');
    _todos = _taskBox!.values.toList();
    notifyListeners();
  }

  Future<void> addTask(String title, String? details) async {
    final newTask = Task(title: title, details: details);
    await _taskBox!.add(newTask);
    _todos = _taskBox!.values.toList();
    notifyListeners();
  }

  Future<void> delete(int index) async {
    if (_taskBox == null) return;
    await _taskBox!.deleteAt(index);
    notifyListeners();
  }

  Future<void> taskCompleted(int index) async {
    if (_taskBox == null) return;
    final task = _todos[index];
    task.isCompleted = !task.isCompleted;
    await task.save();
    notifyListeners();
  }

  Future<void> edit(
      {required int index,
      required String title,
      String? details,
      bool? isCompleted}) async {
    if (_taskBox == null) return;
    final task = _todos[index];
    task.title = title;
    task.details = details;
    task.isCompleted = isCompleted ?? false;
    await task.save();
    notifyListeners();
  }
}
