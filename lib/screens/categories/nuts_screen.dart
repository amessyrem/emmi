import 'package:flutter/material.dart';

class NutsScreen extends StatelessWidget {
  const NutsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> nuts = [
      {"isim": "Ay Çekirdeği", "resim": "assets/images/cekirdek.png"},
      {"isim": "Ceviz", "resim": "assets/images/ceviz.png"},
      {"isim": "Fındık", "resim": "assets/images/fındık.png"},
      {"isim": "Leblebi", "resim": "assets/images/leblebi.png"},
      {"isim": "Yer Fıstığı", "resim": "assets/images/yer fısıtgı.png"},
      {"isim": "Badem", "resim": "assets/images/badem.png"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Kuruyemiş Ürünleri"),
        backgroundColor: Colors.lightGreen,
      ),
      backgroundColor: const Color(0xFFFAF7AC),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: nuts.map((urun) {
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
