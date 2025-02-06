import 'package:flutter/material.dart';

class ShowSnackBar {
  static void show(String message, BuildContext context) {
    final snackBar = SnackBar(content: Text(message));

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
