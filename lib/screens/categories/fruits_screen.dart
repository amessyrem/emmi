import 'package:flutter/material.dart';

class FruitScreen extends StatelessWidget {
  const FruitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meyve')),
      body: Center(
        child: Text('Meyve ürünleri burada gösterilecek.'),
      ),
    );
  }
}