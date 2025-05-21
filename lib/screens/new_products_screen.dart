import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewListingScreen extends StatefulWidget {
  @override
  _NewListingScreenState createState() => _NewListingScreenState();
}

class _NewListingScreenState extends State<NewListingScreen> {
  String? selectedCategory;
  String? selectedSubcategory;
  String? selectedCity;
  String? selectedDistrict;
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();

  final Map<String, List<String>> categoryMap = {
    'Bakliyat': ['nohut', 'mercimek', 'fasulye', 'barbunya', 'bezelye', 'mısır'],
    'Hayvansal Ürünler': ['süt', 'yoğurt', 'bal', 'peynir', 'yağ', 'yumurta'],
    'Kuruyemiş': ['ay çekirdeği', 'ceviz', 'fındık', 'leblebi', 'yer fıstığı', 'badem'],
    'Meyve': ['elma', 'armut', 'portakal', 'kayısı', 'şeftali', 'çilek'],
    'Sebze': ['patates', 'domates', 'patlıcan', 'salatalık', 'ıspanak', 'biber'],
  };

  List<String> cities = [];
  List<String> districts = [];
  bool isLoadingCities = true;
  bool isLoadingDistricts = false;

  @override
  void initState() {
    super.initState();
    loadCities();
  }

  Future<void> loadCities() async {
    try {
      final cityList = await fetchCities();
      setState(() {
        cities = cityList;
        isLoadingCities = false;
      });
    } catch (e) {
      print("İller alınamadı: $e");
    }
  }

  Future<List<String>> fetchCities() async {
    final response = await http.get(Uri.parse("https://turkiyeapi.dev/api/v1/provinces"));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<String>.from(data['data'].map((il) => il['name']));
    } else {
      throw Exception('İller alınamadı');
    }
  }

  Future<List<String>> fetchDistricts(String cityName) async {
    final response = await http.get(Uri.parse("https://turkiyeapi.dev/api/v1/provinces"));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final il = data['data'].firstWhere((il) => il['name'] == cityName);
      return List<String>.from(il['districts'].map((ilce) => ilce['name']));
    } else {
      throw Exception('İlçeler alınamadı');
    }
  }

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
            SizedBox(height: 16),
            Text('İl Seç', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            isLoadingCities
                ? Center(child: CircularProgressIndicator())
                : DropdownButtonFormField<String>(
              value: selectedCity,
              items: cities.map((city) {
                return DropdownMenuItem(
                  value: city,
                  child: Text(city),
                );
              }).toList(),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'İl seç',
              ),
              onChanged: (value) async {
                setState(() {
                  selectedCity = value;
                  selectedDistrict = null;
                  isLoadingDistricts = true;
                });

                try {
                  final districtList = await fetchDistricts(value!);
                  setState(() {
                    districts = districtList;
                    isLoadingDistricts = false;
                  });
                } catch (e) {
                  print("İlçeler alınamadı: $e");
                }
              },
            ),
            if (selectedCity != null) ...[
              SizedBox(height: 16),
              Text('İlçe Seç', style: TextStyle(fontSize: 16)),
              SizedBox(height: 8),
              isLoadingDistricts
                  ? Center(child: CircularProgressIndicator())
                  : DropdownButtonFormField<String>(
                value: selectedDistrict,
                items: districts.map((ilce) {
                  return DropdownMenuItem(
                    value: ilce,
                    child: Text(ilce),
                  );
                }).toList(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'İlçe seç',
                ),
                onChanged: (value) {
                  setState(() {
                    selectedDistrict = value;
                  });
                },
              ),
            ],
            SizedBox(height: 16),
            Text('Fiyat (TL)', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Fiyat giriniz',
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Icon(Icons.currency_lira),
                ),
              ),
            ),
            SizedBox(height: 16),
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
                  final city = selectedCity;
                  final district = selectedDistrict;
                  final description = descriptionController.text;
                  final priceText = priceController.text;

                  if (category == null || subcategory == null || city == null || district == null || description.isEmpty || priceText.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Lütfen tüm alanları doldurunuz.")),
                    );
                    return;
                  }

                  double? price = double.tryParse(priceText);
                  if (price == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Lütfen geçerli bir fiyat giriniz.")),
                    );
                    return;
                  }

                  try {
                    await FirebaseFirestore.instance.collection('ilanlar').add({
                      'userId': FirebaseAuth.instance.currentUser?.uid,
                      'kategori': category,
                      'altKategori': subcategory,
                      'il': city,
                      'ilce': district,
                      'fiyat': price,
                      'aciklama': description,
                      'createdAt': FieldValue.serverTimestamp(),
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Ürün başarıyla kaydedildi.")),
                    );

                    setState(() {
                      selectedCategory = null;
                      selectedSubcategory = null;
                      selectedCity = null;
                      selectedDistrict = null;
                      descriptionController.clear();
                      priceController.clear();
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
                child: Text("Ürünü Kaydet", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
