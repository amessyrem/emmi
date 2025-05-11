import 'package:flutter/material.dart';

class VegetablesScreen extends StatelessWidget {
  const VegetablesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> vegetables = [
      {"isim": "Patates", "resim": "assets/images/patates.png"},
      {"isim": "Domates", "resim": "assets/images/domates.png"},
      {"isim": "Patlıcan", "resim": "assets/images/patlıcan.png"},
      {"isim": "Salatalık", "resim": "assets/images/salatalık.png"},
      {"isim": "Ispanak", "resim": "assets/images/ispanak.png"},
      {"isim": "Biber", "resim": "assets/images/biber.png"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sebze Ürünleri"),
        backgroundColor: Colors.lightGreen,
      ),
      backgroundColor: const Color(0xFFFAF7AC),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: vegetables.map((urun) {
            return Container(
              decoration: BoxDecoration(
                color: const Color(0x106FAF37),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    urun["resim"]!,
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 50),
                  Text(
                    urun["isim"]!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
