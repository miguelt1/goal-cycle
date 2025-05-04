import 'package:flutter/material.dart';
import '../models/goal.dart';

class GoalTile extends StatelessWidget {
  final Goal goal;
  final ValueChanged<bool?> onCheckboxChanged;
  final VoidCallback onEdit;

  const GoalTile({
    Key? key,
    required this.goal,
    required this.onCheckboxChanged,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(goal.title),
      leading: Checkbox(
        value: goal.isCompleted,
        onChanged: onCheckboxChanged,
      ),
      trailing: IconButton(
        icon: Icon(Icons.edit),
        onPressed: onEdit,
      ),
    );
  }
}