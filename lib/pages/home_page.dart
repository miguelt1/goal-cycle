import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/goal.dart';
import '../models/cycle.dart';
import '../widgets/goal_tile.dart';
import '../widgets/timer_circle.dart';
import 'goal_form_page.dart';
import 'history_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int _elapsedSeconds;
  Timer? _timer;
  DateTime? _startTime;
  final _goalsBox = Hive.box<Goal>('goals');
  final _cyclesBox = Hive.box<Cycle>('cycles');
  final _timerBox = Hive.box('timerState'); // Box para estado do timer

  @override
  void initState() {
    super.initState();
    _loadTimerState();
  }

  void _loadTimerState() {
    // Carregar estado salvo
    _elapsedSeconds = _timerBox.get('elapsedSeconds', defaultValue: 0);
    final savedStartTime = _timerBox.get('startTime');

    if (savedStartTime != null) {
      // Calcular tempo decorrido desde o último fechamento
      final difference = DateTime.now().difference(savedStartTime);
      _elapsedSeconds += difference.inSeconds;
      _startTimer(); // Reiniciar o timer automaticamente
    }
  }

  void _startTimer() {
    if (_timer == null) {
      _startTime = DateTime.now();
      _timerBox.put('startTime', _startTime); // Salvar hora de início
      
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _elapsedSeconds++;
          _timerBox.put('elapsedSeconds', _elapsedSeconds); // Atualizar a cada segundo
        });
      });
    }
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
    _timerBox
      ..delete('startTime')
      ..put('elapsedSeconds', _elapsedSeconds);
  }

  void _addGoal() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const GoalFormPage()),
    );
    if (_goalsBox.isNotEmpty) _startTimer();
  }

  void _editGoal(int index) async {
    final goal = _goalsBox.getAt(index);
    if (goal != null) {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => GoalFormPage(goal: goal)),
      );
    }
  }

  void _completeCycle() {
    final goals = _goalsBox.values.toList();
    final cycle = Cycle(
      goals: goals,
      startTime: _startTime!,
      endTime: DateTime.now(),
      totalSeconds: _elapsedSeconds,
    );

    _cyclesBox.add(cycle);
    _goalsBox.clear();
    _stopTimer();
    
    setState(() {
      _elapsedSeconds = 0;
      _startTime = null;
    });
    
    // Limpar estado do timer
    _timerBox.delete('elapsedSeconds');
  }

  @override
  void dispose() {
    _timerBox.put('elapsedSeconds', _elapsedSeconds); // Último salvamento
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(int seconds) {
    final d = Duration(seconds: seconds);
    final hours = d.inHours.remainder(24);
    final minutes = d.inMinutes.remainder(60);
    final secs = d.inSeconds.remainder(60);
    return '${hours}h ${minutes}m ${secs}s';
  }

  double _completionPercent() {
    if (_goalsBox.isEmpty) return 0.0;
    final completed = _goalsBox.values.where((g) => g.isCompleted).length;
    return completed / _goalsBox.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Objetivos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HistoryPage()),
            ),
          ),
        ],
      ),
      body: ValueListenableBuilder<Box<Goal>>(
        valueListenable: _goalsBox.listenable(),
        builder: (context, box, _) {
          if (box.isEmpty) {
            return Center(
              child: Text(
                'Nenhum ciclo ativo.\nToque em "+" para começar.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            );
          }

          return Column(
            children: [
              const SizedBox(height: 16),
              TimerCircle(
                elapsedSeconds: _elapsedSeconds,
                progress: _completionPercent(),
                timeFormatted: _formatDuration(_elapsedSeconds),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    final goal = box.getAt(index);
                    return GoalTile(
                      goal: goal!,
                      onCheckboxChanged: (value) {
                        goal.isCompleted = value ?? false;
                        goal.save();
                      },
                      onEdit: () => _editGoal(index),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton.icon(
                  onPressed: _goalsBox.values.any((g) => !g.isCompleted)
                      ? null
                      : _completeCycle,
                  icon: const Icon(Icons.check),
                  label: const Text('Concluir Ciclo'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addGoal,
        child: const Icon(Icons.add),
      ),
    );
  }
}