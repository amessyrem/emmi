import 'package:flutter/material.dart';

class MeatScreen extends StatelessWidget {
  const MeatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hayvansal Ürünler')),
      body: const Center(child: Text('Hayvansal ürünler burada.')),
    );
  }
}