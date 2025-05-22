import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AltKategoriSahipleriEkrani extends StatelessWidget {
  final String altKategori;

  const AltKategoriSahipleriEkrani({Key? key, required this.altKategori}) : super(key: key);

  // Belirli bir userId için kullanıcı bilgilerini getir
  Future<Map<String, dynamic>?> _getUserInfo(String userId) async {
    try {
      final doc = await FirebaseFirestore.instance.collection('kullanicilar').doc(userId).get();
      if (doc.exists) {
        return doc.data();
      }
    } catch (e) {
      print("Kullanıcı verisi alınamadı: $e");
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "$altKategori İçin İlan Verenler",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF0D5944),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('ilanlar')
            .where('kategori', isEqualTo: "Hayvansal Ürünler")
            .where('altKategori', isEqualTo: altKategori.toLowerCase())
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
                    // KULLANICI BULUNAMADI – UID yanlış olabilir
                    print("Kullanıcı bulunamadı! UID: $userId");
                    return ListTile(
                      leading: const Icon(Icons.eco, color: Colors.grey),
                      title: const Text("İLAN SAHİBİ: Bulunamadı"),
                      subtitle: Text("AÇIKLAMA: $aciklama"),
                    );
                  }

                  final user = userSnapshot.data!;
                  final isim = user['isim'] ?? 'Bilinmiyor';
                  final soyisim = user['soyisim'] ?? '';

                  return ListTile(
                    leading: const Icon(Icons.eco, color: Colors.green),
                    title: Text("İLAN SAHİBİ: $isim $soyisim"),
                    subtitle: Text("AÇIKLAMA: $aciklama"),
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
