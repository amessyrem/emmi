import 'package:flutter/material.dart';

class AllProductsScreen extends StatelessWidget {
  const AllProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tüm Ürünler')),
      body: const Center(child: Text('Tüm ürünler burada listelenecek.')),
    );
  }
}
