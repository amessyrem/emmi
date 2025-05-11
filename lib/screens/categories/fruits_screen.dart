import 'package:flutter/material.dart';

class FruitsScreen extends StatelessWidget {
  const FruitsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> fruits = [
      {"isim": "Elma", "resim": "assets/images/elma.png"},
      {"isim": "Armut", "resim": "assets/images/armut.png"},
      {"isim": "Portakal", "resim": "assets/images/portakal.png"},
      {"isim": "Kayısı", "resim": "assets/images/kayısı.png"},
      {"isim": "Şeftali", "resim": "assets/images/seftali.png"},
      {"isim": "Çilek", "resim": "assets/images/clk.png"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Meyve Ürünleri"),
        backgroundColor: Colors.lightGreen,
      ),
      backgroundColor: const Color(0xFFFAF7AC),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: fruits.map((urun) {
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
