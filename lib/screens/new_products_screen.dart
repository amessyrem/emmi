import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewListingScreen extends StatefulWidget {
  @override
  _NewListingScreenState createState() => _NewListingScreenState();
}

class _NewListingScreenState extends State<NewListingScreen> {
  String? selectedCategory;
  String? selectedSubcategory;
  final descriptionController = TextEditingController();

  final Map<String, List<String>> categoryMap = {
    'Bakliyat': ['nohut', 'mercimek', 'fasulye', 'barbunya', 'bezelye', 'mısır'],
    'Hayvansal Ürünler': ['süt', 'yoğurt', 'bal', 'peynir', 'yağ', 'yumurta'],
    'Kuruyemiş': ['ay çekirdeği', 'ceviz', 'fındık', 'leblebi', 'yer fıstığı', 'badem'],
    'Meyve': ['elma', 'armut', 'portakal', 'kayısı', 'şeftali', 'çilek'],
    'Sebze': ['patates', 'domates', 'patlıcan', 'salatalık', 'ıspanak', 'biber'],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF1E7E4),
      appBar: AppBar(
        title: Text('Yeni Ürün', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF0D5944),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Kategori Seç', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              items: categoryMap.keys.map((category) {
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
                  selectedSubcategory = null;
                });
              },
            ),
            if (selectedCategory != null) ...[
              SizedBox(height: 16),
              Text('Alt Kategori Seç', style: TextStyle(fontSize: 16)),
              SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedSubcategory,
                items: categoryMap[selectedCategory!]!.map((subcategory) {
                  return DropdownMenuItem(
                    value: subcategory,
                    child: Text(subcategory),
                  );
                }).toList(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Alt kategori seç',
                ),
                onChanged: (value) {
                  setState(() {
                    selectedSubcategory = value;
                  });
                },
              ),
            ],
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
                  final subcategory = selectedSubcategory;
                  final description = descriptionController.text;

                  if (category == null || subcategory == null || description.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Lütfen tüm alanları doldurunuz.")),
                    );
                    return;
                  }

                  try {
                    await FirebaseFirestore.instance.collection('ilanlar').add({
                      'userId': FirebaseAuth.instance.currentUser?.uid,
                      'kategori': category,
                      'altKategori': subcategory,
                      'aciklama': description,
                      'createdAt': FieldValue.serverTimestamp(),
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Ürün başarıyla kaydedildi.")),
                    );

                    setState(() {
                      selectedCategory = null;
                      selectedSubcategory = null;
                      descriptionController.clear();
                    });
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Hata oluştu: $e")),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF0D5944),
                ),
                child: Text("Ürünü kaydet", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
