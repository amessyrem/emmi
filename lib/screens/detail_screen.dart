import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final int index;
  final String name;

  DetailScreen({required this.index, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$name Sayfası')),
      body: Center(
        child: Text('$name - Burası Ekran $index', style: TextStyle(fontSize: 22)),
      ),
    );
  }
}
