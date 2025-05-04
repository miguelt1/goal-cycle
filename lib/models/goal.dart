import 'package:hive/hive.dart';

part 'goal.g.dart';

@HiveType(typeId: 0)
class Goal extends HiveObject {
  @HiveField(0)
  final String title;
  @HiveField(1)
  bool isCompleted;

  Goal({required this.title, this.isCompleted = false});
}