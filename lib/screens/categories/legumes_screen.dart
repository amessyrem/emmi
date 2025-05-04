import 'package:flutter/material.dart';

class BakliyatEkrani extends StatelessWidget {
  const BakliyatEkrani({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> bakliyatlar = [
      {"isim": "Nohut", "resim": "assets/images/nohut.png"}, // Dosya adını güncelledik
      {"isim": "Mercimek", "resim": "assets/images/mercimek.png"},
      {"isim": "Fasulye", "resim": "assets/images/fasulye.png"},
      {"isim": "Barbunya", "resim": "assets/images/barbunya.png"},
      {"isim": "Bezelye", "resim": "assets/images/beans-161504_1280.png"},
      {"isim": "Mısır", "resim": "assets/images/misir.png"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Bakliyat Ürünleri"),
        backgroundColor: Colors.lightGreen,
      ),
      backgroundColor: const Color(0xFFFAF7AC),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: bakliyatlar.map((urun) {
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
                      fontSize:20,
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