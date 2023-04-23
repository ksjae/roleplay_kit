import 'package:flutter/material.dart';
import 'views/chat_window.dart';
import 'views/character_widgets.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChatWindow(),
    );
  }
}
