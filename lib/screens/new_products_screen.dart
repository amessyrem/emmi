import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewListingScreen extends StatefulWidget {
  @override
  _NewListingScreenState createState() => _NewListingScreenState();
}

class _NewListingScreenState extends State<NewListingScreen> {
  String? selectedCategory;
  final descriptionController = TextEditingController();

  final List<String> categories = [
    'Bakliyat', 'Hayvansal Ürünler', 'Kuruyemiş', 'Meyve', 'Sebze', 'Tüm Ürünler',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAF7AC),


      appBar: AppBar(
        title: Text('Yeni Ürün'),
        backgroundColor: Color(0x846FAF37),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Kategoriler', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            DropdownButtonFormField<String>(
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
            SizedBox(height: 24),
            Text('Açıklama', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            TextField(
              controller: descriptionController,
              maxLines: 5,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Ürün detaylarını giriniz...',
              ),
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                  onPressed: () async {
                    final category = selectedCategory;
                    final description = descriptionController.text;
                    final user = FirebaseAuth.instance.currentUser;

                    if (category == null || description.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Lütfen tüm boşlukları doldurunuz.")),
                      );
                      return;
                    }

                    try {
                      await FirebaseFirestore.instance.collection('ilanlar').add({
                        'userId': user?.uid,
                        'kategori': category,
                        'aciklama': description,
                        'createdAt': Timestamp.now(),
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Ürün başarıyla kaydedildi.")),
                      );

                      // Formu sıfırla
                      setState(() {
                        selectedCategory = null;
                        descriptionController.clear();
                      });
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Hata oluştu: $e")),
                      );
                    }
                  },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0x846FAF37),
                ),
                child: Text("Ürünü kaydet"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
