import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FruitDetailScreen(altKategori: urun["isim"]!),
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

class FruitDetailScreen extends StatelessWidget {
  final String altKategori;

  const FruitDetailScreen({Key? key, required this.altKategori}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7AC),
      appBar: AppBar(
        title: Text("$altKategori İçin İlanlar"),
        backgroundColor: const Color(0x846FAF37),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('ilanlar')
            .where('kategori', isEqualTo: 'Meyve')
            .where('altKategori', isEqualTo: altKategori) // filtre burada
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Bir hata oluştu."));
          }
          final docs = snapshot.data?.docs;
          if (docs == null || docs.isEmpty) {
            return Center(child: Text("$altKategori için ilan bulunamadı."));
          }
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final ilan = docs[index];
              return Card(
                color: const Color(0x106FAF37),
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.local_offer, color: Color(0x846FAF37)),
                  title: Text(ilan['kategori'] ?? 'Kategori Yok'),
                  subtitle: Text(ilan['aciklama'] ?? 'Açıklama yok'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
