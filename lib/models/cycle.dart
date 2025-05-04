import 'package:hive/hive.dart';
import 'goal.dart';

part 'cycle.g.dart';

@HiveType(typeId: 1)
class Cycle extends HiveObject {
  @HiveField(0)
  List<Goal> goals;

  @HiveField(1)
  DateTime startTime;

  @HiveField(2)
  DateTime? endTime;

  @HiveField(3)
  int totalSeconds;

  Cycle({
    required this.goals,
    required this.startTime,
    this.endTime,
    this.totalSeconds = 0,
  });
}
