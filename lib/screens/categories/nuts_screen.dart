import 'package:flutter/material.dart';

class NutsScreen extends StatelessWidget {
  const NutsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kuruyemiş')),
      body: const Center(child: Text('Kuruyemiş ürünleri burada.')),
    );
  }
}
