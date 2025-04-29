import 'package:flutter/material.dart';

class LegumesScreen extends StatelessWidget {
  const LegumesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bakliyat')),
      body: Center(
        child: Text('Bakliyat ürünleri burada gösterilecek.'),
      ),
    );
  }
}