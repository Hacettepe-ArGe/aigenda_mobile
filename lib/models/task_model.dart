import 'package:flutter/material.dart';

class Task {
  String title;
  String description;
  DateTime date;
  TimeOfDay time;
  int priority;

  Task({
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.priority,
  });
}
