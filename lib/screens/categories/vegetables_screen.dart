import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SebzeSahipleriEkrani extends StatelessWidget {
  final String altKategori;

  const SebzeSahipleriEkrani({Key? key, required this.altKategori}) : super(key: key);

  Future<Map<String, dynamic>?> _getUserInfo(String userId) async {
    final userDoc = await FirebaseFirestore.instance.collection('kullanicilar').doc(userId).get();
    if (userDoc.exists) {
      return userDoc.data();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // Ispanak için özel karakter düzeltmesi
    final duzeltilmisAltKategori =
    altKategori == "Ispanak" ? "ıspanak" : altKategori.toLowerCase();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "$altKategori İçin İlan Verenler",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0D5944),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('ilanlar')
            .where('kategori', isEqualTo: "Sebze")
            .where('altKategori', isEqualTo: duzeltilmisAltKategori)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Bu alt kategoride ilan bulunamadı."));
          }

          final ilanlar = snapshot.data!.docs;

          return ListView.builder(
            itemCount: ilanlar.length,
            itemBuilder: (context, index) {
              final ilan = ilanlar[index];
              final userId = ilan['userId'];
              final aciklama = ilan['aciklama'] ?? 'Açıklama yok';

              return FutureBuilder<Map<String, dynamic>?>(
                future: _getUserInfo(userId),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return const ListTile(title: Text("Yükleniyor..."));
                  }

                  if (!userSnapshot.hasData || userSnapshot.data == null) {
                    return const ListTile(title: Text("Kullanıcı bilgisi bulunamadı"));
                  }

                  final user = userSnapshot.data!;
                  final isim = user['isim'];
                  final soyisim = user['soyisim'];

                  return ListTile(
                    leading: const Icon(Icons.eco, color: Colors.green, size: 28),
                    title: Text(
                      "İLAN SAHİBİ: $isim $soyisim",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black87,
                      ),
                    ),
                    subtitle: Text(
                      "AÇIKLAMA: $aciklama",
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.grey[700],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

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
        title: const Text("Sebze Ürünleri", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF0D5944),
      ),
      backgroundColor: const Color(0xFFF1E7E4),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: vegetables.map((urun) {
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SebzeSahipleriEkrani(altKategori: urun["isim"]!),
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
