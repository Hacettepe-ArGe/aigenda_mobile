import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  //Theme
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  //Size-MediaQuery
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get screenSize => mediaQuery.size;
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;
  bool get isSmall => screenWidth < 500;

  //Navigation
  void navigateBack() => Navigator.pop(this);
  Future navigate(String routeName) => Navigator.pushNamed(this, routeName);
  Future<T?> navigateWithArguments<T>(String routeName, {Object? arguments}) => Navigator.pushNamed<T>(
        this,
        routeName,
        arguments: arguments,
      );

  Future navigateRemoveUntil(String routeName) => Navigator.of(this).pushNamedAndRemoveUntil(routeName, (_) => false);
  void showMessage(String text) => ScaffoldMessenger.of(this).showSnackBar(SnackBar(content: Text(text)));
}
