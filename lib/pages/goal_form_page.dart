import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/goal.dart';

class GoalFormPage extends StatefulWidget {
  final Goal? goal;

  const GoalFormPage({Key? key, this.goal}) : super(key: key);

  @override
  _GoalFormPageState createState() => _GoalFormPageState();
}

class _GoalFormPageState extends State<GoalFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();

  bool get isEditing => widget.goal != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _titleController.text = widget.goal!.title;
    }
  }

  void _saveGoal() async {
    if (_formKey.currentState!.validate()) {
      final box = Hive.box<Goal>('goals');

      if (isEditing) {
        // Atualizar objetivo existente
        final key = widget.goal!.key;
        final updatedGoal = Goal(title: _titleController.text);
        await box.put(key, updatedGoal);
      } else {
        // Adicionar novo objetivo
        final newGoal = Goal(title: _titleController.text);
        await box.add(newGoal);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Objetivo' : 'Adicionar Objetivo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Título'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor insere um título';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveGoal,
                child: Text(isEditing ? 'Editar' : 'Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}