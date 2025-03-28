import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'category_model.dart';

class Task {
  String? id;
  String title;
  String description;
  DateTime date;
  TimeOfDay time;
  int priority;
  Category? category; // ✅ new
  String? userid;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.priority,
    this.userid,
    this.category,
  });

  factory Task.fromMap(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Task(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      date: data['date'] != null ? data['date'].toDate() : DateTime.now(),
      time: TimeOfDay(hour: int.parse(data['time'].toString().split("*").first), minute: int.parse(data['time'].toString().split("*").last)),
      priority: data['priority'] ?? 0,
      category: data['category'] != null ? Category.fromMap(data['category']) : null,
      userid: data['userid'],
    );
  }

  // Method to convert a User object to a map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'date': Timestamp.fromDate(date),
      'time': ("${time.hour}*${time.minute}"),
      'priority': priority,
      'category': category?.toMap(),
      'userid': userid,
    };
  }
}
