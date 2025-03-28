import 'package:flutter/material.dart';

extension StringExtension on String {
  //Assets images
  String toAssetImage() => "assets/images/$this";
}
