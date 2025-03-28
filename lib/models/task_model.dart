import 'package:flutter/material.dart';
import 'category_model.dart';

class Task {
  String title;
  String description;
  DateTime date;
  TimeOfDay time;
  int priority;
  Category? category; // ✅ new

  Task({
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.priority,
    this.category,
  });
}
