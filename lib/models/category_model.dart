import 'dart:convert';
import 'package:flutter/material.dart';

class Category {
  final String name;
  final IconData icon;
  final Color color;

  Category({
    required this.name,
    required this.icon,
    required this.color,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'icon': toJSONString(icon),
      'color': color.value,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      name: map['name'],
      icon: fromJSONString(map['icon']),
      color: Color(map['color']),
    );
  }

  static String toJSONString(IconData data) {
    Map<String, dynamic> map = <String, dynamic>{};
    map['codePoint'] = data.codePoint;
    map['fontFamily'] = data.fontFamily;
    map['fontPackage'] = data.fontPackage;
    map['matchTextDirection'] = data.matchTextDirection;
    return jsonEncode(map);
  }

  static IconData fromJSONString(String jsonString) {
    Map<String, dynamic> map = jsonDecode(jsonString);
    return IconData(
      map['codePoint'],
      fontFamily: map['fontFamily'],
      fontPackage: map['fontPackage'],
      matchTextDirection: map['matchTextDirection'],
    );
  }
}
