import 'package:flutter/material.dart';

class VegetablesScreen extends StatelessWidget {
  const VegetablesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sebze')),
      body: const Center(child: Text('Sebze ürünleri burada.')),
    );
  }
}
