import 'package:flutter/material.dart';
import '../models/task_model.dart';

class TaskTile extends StatelessWidget {
  final Task task;

  const TaskTile({super.key, required this.task});

  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return const Color(0xFFE57373); // Red
      case 2:
        return const Color(0xFFFFB74D); // Orange
      case 3:
        return const Color(0xFF64B5F6); // Blue
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1E1E1E),
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Title
            Text(
              task.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            /// Description
            if (task.description.isNotEmpty)
              Text(
                task.description,
                style: const TextStyle(color: Colors.white70),
              ),

            const SizedBox(height: 12),

            /// Date + Time + Priority row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Colors.white54, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      "${task.date.day}/${task.date.month}/${task.date.year}",
                      style: const TextStyle(color: Colors.white54),
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.access_time, color: Colors.white54, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      task.time.format(context),
                      style: const TextStyle(color: Colors.white54),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: getPriorityColor(task.priority),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'P${task.priority}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
