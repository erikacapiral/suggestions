import 'package:flutter/material.dart';
import 'package:tips_and_resources/screen.dart';

void main() {
  runApp(const WasteNot());
}

class WasteNot extends StatelessWidget {
  const WasteNot({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
