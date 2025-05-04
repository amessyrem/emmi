import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyProductsScreen extends StatefulWidget {
  @override
  _MyProductsScreenState createState() => _MyProductsScreenState();
}

class _MyProductsScreenState extends State<MyProductsScreen> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAF7AC),
      appBar: AppBar(
        title: Text("Ürünlerim"),
        backgroundColor: Color(0x846FAF37),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('ilanlar') // Küçük harf olmalı!
            .where('userId', isEqualTo: user?.uid)
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Bir hata meydana geldi."));
          }

          final docs = snapshot.data?.docs;
          if (docs == null || docs.isEmpty) {
            return Center(
              child: Text(
                "Henüz bir ilanınız yok.",
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final ilan = docs[index];
              return Card(
                color: Color(0x106FAF37),
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: Icon(Icons.local_offer, color: Color(0x846FAF37)),
                  title: Text(ilan['kategori'] ?? 'Kategori Yok'),
                  subtitle: Text(ilan['aciklama'] ?? 'Açıklama yok'),
                  trailing: Tooltip(
                    message: 'Ürün duyurusunu kaldır',
                    child: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        final shouldDelete = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Ürünü sil'),
                            content: Text('Bu ürünü silmek istediğinize emin misiniz?'),
                            actions: [
                              TextButton(
                                child: Text('İptal'),
                                onPressed: () => Navigator.pop(context, false),
                              ),
                              TextButton(
                                child: Text('Sil'),
                                onPressed: () => Navigator.pop(context, true),
                              ),
                            ],
                          ),
                        );

                        if (shouldDelete == true) {
                          await FirebaseFirestore.instance
                              .collection('ilanlar')
                              .doc(ilan.id)
                              .delete();
                        }
                      },
                    ),
                  ),
                ),

              );
            },
          );
        },
      ),
    );
  }
}
