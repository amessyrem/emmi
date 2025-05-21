import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FilteredProductsScreen extends StatelessWidget {
  final String kategori;
  final String altKategori;
  final String il;
  final String ilce;

  const FilteredProductsScreen({
    Key? key,
    required this.kategori,
    required this.altKategori,
    required this.il,
    required this.ilce,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Query query = FirebaseFirestore.instance
        .collection('ilanlar')
        .where('kategori', isEqualTo: kategori);

    // Alt kategori seçilmişse filtre uygula
    if (altKategori.isNotEmpty && altKategori.toLowerCase() != 'hepsi') {
      query = query.where('altKategori', isEqualTo: altKategori);
    }

    if (il.isNotEmpty) {
      query = query.where('il', isEqualTo: il);
    }

    if (ilce.isNotEmpty) {
      query = query.where('ilce', isEqualTo: ilce);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Filtrelenmiş Ürünler'),
        backgroundColor: Color(0xFF0D5944),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: query.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return Center(child: Text('Hiç ürün bulunamadı.'));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                elevation: 3,
                child: ListTile(
                  title: Text(data['altKategori'] ?? 'Ürün'),
                  subtitle: Text("${data['il']}, ${data['ilce']}"),
                  trailing: Text("${data['fiyat']} TL"),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
