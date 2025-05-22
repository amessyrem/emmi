import 'package:flutter/material.dart';
import 'filtered_products_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductFilterScreen extends StatefulWidget {
  @override
  _ProductFilterScreenState createState() => _ProductFilterScreenState();
}

class _ProductFilterScreenState extends State<ProductFilterScreen> {
  String? selectedCategory;
  String? selectedSubcategory;
  String? selectedCity;
  String? selectedDistrict;

  final Map<String, List<String>> categoryMap = {
    'Bakliyat': ['nohut', 'mercimek', 'fasulye', 'barbunya', 'bezelye', 'mısır'],
    'Meyve': ['elma', 'armut', 'portakal', 'kayısı', 'şeftali', 'çilek'],
    'Sebze': ['patates', 'domates', 'patlıcan', 'salatalık', 'ıspanak', 'biber'],
    'Kuruyemiş': ['ay çekirdeği', 'ceviz', 'fındık', 'leblebi', 'yer fıstığı', 'badem'],
    'Hayvansal Ürünler': ['süt', 'yoğurt', 'bal', 'peynir', 'yağ', 'yumurta'],
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
    final response = await http.get(Uri.parse("https://turkiyeapi.dev/api/v1/provinces"));
    final decoded = json.decode(response.body);
    setState(() {
      cities = List<String>.from(decoded['data'].map((e) => e['name']));
      isLoadingCities = false;
    });
  }

  Future<void> loadDistricts(String cityName) async {
    setState(() => isLoadingDistricts = true);

    final response = await http.get(Uri.parse("https://turkiyeapi.dev/api/v1/provinces"));
    final decoded = json.decode(response.body);
    final selected = decoded['data'].firstWhere((il) => il['name'] == cityName);
    setState(() {
      districts = List<String>.from(selected['districts'].map((d) => d['name']));
      isLoadingDistricts = false;
    });
  }

  Query buildQuery() {
    Query query = FirebaseFirestore.instance.collection('ilanlar');

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      query = query.where('userId', isEqualTo: currentUser.uid);
    }

    if (selectedCategory != null && selectedCategory!.isNotEmpty) {
      query = query.where('kategori', isEqualTo: selectedCategory!);
    }

    if (selectedSubcategory != null && selectedSubcategory!.isNotEmpty) {
      query = query.where('altKategori', isEqualTo: selectedSubcategory!.toLowerCase());
    }

    if (selectedCity != null && selectedCity!.isNotEmpty) {
      query = query.where('il', isEqualTo: selectedCity);
    }

    if (selectedDistrict != null && selectedDistrict!.isNotEmpty) {
      query = query.where('ilce', isEqualTo: selectedDistrict);
    }

    return query;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ürünler'), backgroundColor: Color(0xFF0D5944)),
      body: Column(
        children: [
          // Filtreler
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedCategory,
                        items: categoryMap.keys
                            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value;
                            selectedSubcategory = null;
                          });
                        },
                        decoration: InputDecoration(labelText: 'Kategori'),
                      ),
                    ),
                    SizedBox(width: 16), // Araya boşluk
                    if (selectedCategory != null)
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          key: ValueKey(selectedCategory),
                          value: selectedSubcategory,
                          items: categoryMap[selectedCategory!]!
                              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedSubcategory = value;
                            });
                          },
                          decoration: InputDecoration(labelText: 'Alt Kategori'),
                        ),
                      ),
                  ],
                ),

                SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: isLoadingCities
                          ? Center(child: CircularProgressIndicator())
                          : DropdownButtonFormField<String>(
                        value: selectedCity,
                        items: cities
                            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (value) async {
                          setState(() {
                            selectedCity = value;
                            selectedDistrict = null;
                            districts = [];
                          });
                          if (value != null) await loadDistricts(value);
                        },
                        decoration: InputDecoration(labelText: 'İl'),
                      ),
                    ),
                    SizedBox(width: 16),
                    if (selectedCity != null && !isLoadingDistricts)
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: selectedDistrict,
                          items: districts
                              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedDistrict = value;
                            });
                          },
                          decoration: InputDecoration(labelText: 'İlçe'),
                        ),
                      ),
                  ],
                ),
              ],
            )
          ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: buildQuery().snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("İlan bulunamadı."));
                }

                final ilanlar = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: ilanlar.length,
                  itemBuilder: (context, index) {
                    final ilan = ilanlar[index];
                    return ListTile(
                      title: Text(ilan['altKategori'] ?? ''),
                      subtitle: Text("İl: ${ilan['il'] ?? '-'} - İlçe: ${ilan['ilce'] ?? '-'}"),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
