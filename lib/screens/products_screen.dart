import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyProductsScreen extends StatefulWidget {
  @override
  _MyProductsScreenState createState() => _MyProductsScreenState();
}

class _MyProductsScreenState extends State<MyProductsScreen> {
  final user = FirebaseAuth.instance.currentUser;
  String? selectedCategory;

  final List<String> categories = [
    'Bakliyat', 'Hayvansal Ürünler', 'Kuruyemiş', 'Meyve', 'Sebze'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ürünlerim", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF0D5944),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Kategori seçimi
          Padding(
            padding: EdgeInsets.all(16),
            child: DropdownButtonFormField<String>(
              value: selectedCategory,
              items: categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Kategori seç',
              ),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value;
                });
              },
            ),
          ),

          if (selectedCategory == null)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text("Bir kategori seçiniz.", style: TextStyle(fontSize: 16)),
            )
          else
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('ilanlar')
                    .where('userId', isEqualTo: user?.uid)
                    .where('kategori', isEqualTo: selectedCategory)
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    print("Hata Detayı: ${snapshot.error}");
                    return Center(
                        child: Text("Hata: ${snapshot.error}"),);
                  }

                  final docs = snapshot.data?.docs;

                  if (docs == null || docs.isEmpty) {
                    return Center(
                      child: Text(
                        "Bu kategoride ilanınız yok.",
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final ilan = docs[index];
                      final altKategori = ilan['altKategori'] ?? 'Alt kategori yok';
                      final aciklama = ilan['aciklama'] ?? 'Açıklama yok';

                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 4,
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$altKategori',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Color(0xFF0D5944),
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(aciklama),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  tooltip: 'İlanı sil',
                                  onPressed: () async {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title: Text('İlanı Sil'),
                                        content: Text('Bu ilanı silmek istiyor musunuz?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context, false),
                                            child: Text('İptal'),
                                          ),
                                          TextButton(
                                            onPressed: () => Navigator.pop(context, true),
                                            child: Text('Sil'),
                                          ),
                                        ],
                                      ),
                                    );

                                    if (confirm == true) {
                                      await FirebaseFirestore.instance
                                          .collection('ilanlar')
                                          .doc(ilan.id)
                                          .delete();
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            )
        ],
      ),
    );
  }
}