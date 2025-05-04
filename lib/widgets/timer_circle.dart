import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class TimerCircle extends StatelessWidget {
  final int elapsedSeconds;
  final double progress;
  final String timeFormatted;

  const TimerCircle({
    Key? key,
    required this.elapsedSeconds,
    required this.progress,
    required this.timeFormatted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: 100.0,
      lineWidth: 13.0,
      animation: true,
      percent: progress.clamp(0.0, 1.0),
      center: Text(
        timeFormatted,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      circularStrokeCap: CircularStrokeCap.round,
      progressColor: Colors.green,
      backgroundColor: Colors.grey.shade300,
    );
  }
}
