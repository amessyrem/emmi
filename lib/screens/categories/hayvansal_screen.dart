import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'AltKategoriSahipleriEkrani.dart';

class HayvansalUrunlerEkrani extends StatelessWidget {
  const HayvansalUrunlerEkrani({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> hayvansalUrunler = [
      {"isim": "Süt", "resim": "assets/images/sut.png"},
      {"isim": "Yoğurt", "resim": "assets/images/yogurt.png"},
      {"isim": "Bal", "resim": "assets/images/bal.png"},
      {"isim": "Peynir", "resim": "assets/images/peynir.png"},
      {"isim": "Yağ", "resim": "assets/images/yag.png"},
      {"isim": "Yumurta", "resim": "assets/images/yumurta.png"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Hayvansal Ürünler", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF0D5944),
      ),
      backgroundColor: const Color(0xFFF1E7E4),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: hayvansalUrunler.map((urun) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AltKategoriSahipleriEkrani(altKategori: urun["isim"]!),
                  ),
                );
              },
              child: Container(
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
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
