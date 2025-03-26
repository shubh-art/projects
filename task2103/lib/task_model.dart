import 'package:hive/hive.dart';
part 'task_model.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(1)
  String title;
  @HiveField(2)
  String? details;
  @HiveField(3)
  bool isCompleted;

  Task({required this.title, this.details, this.isCompleted = false});
}
