import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AltKategoriSahipleriEkrani extends StatelessWidget {
  final String altKategori;

  const AltKategoriSahipleriEkrani({Key? key, required this.altKategori}) : super(key: key);


  // Kullanıcı bilgilerini getir
  Future<Map<String, dynamic>?> _getUserInfo(String userId) async {
    final userDoc = await FirebaseFirestore.instance.collection('kullanicilar').doc(userId).get();
    if (userDoc.exists) {
      return userDoc.data();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "$altKategori İçin İlan Verenler",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF0D5944),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('ilanlar')
            .where('kategori', isEqualTo: "Hayvansal Ürünler")
            .where('altKategori', isEqualTo: altKategori.toLowerCase()) // dikkat!
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("Bu alt kategoride ilan bulunamadı."));
          }

          final ilanlar = snapshot.data!.docs;

          return ListView.builder(
            itemCount: ilanlar.length,
            itemBuilder: (context, index) {
              final ilan = ilanlar[index];
              final userId = ilan['userId'];

              return FutureBuilder<Map<String, dynamic>?>(
                future: _getUserInfo(userId),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return ListTile(title: Text("Yükleniyor..."));
                  }

                  if (!userSnapshot.hasData || userSnapshot.data == null) {
                    final aciklama = ilan['aciklama'] ?? 'Açıklama yok';
                    return ListTile(
                      leading: Icon(Icons.eco, color: Colors.green),
                      title: Text("İLAN SAHİBİ: null"),
                      subtitle: Text("AÇIKLAMA: $aciklama"),
                    );
                  }

                  final user = userSnapshot.data!;
                  print("Kullanıcı verisi: $user");



                  final isim = user['isim'] ?? 'Bilinmiyor';
                  final soyisim = user['soyisim'] ?? '';
                  final aciklama = ilan['aciklama'] ?? 'Açıklama yok';

                  return ListTile(
                    leading: Icon(Icons.eco, color: Colors.green),
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