import 'package:flutter/material.dart';
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
    'Yardımlaşma': ['ilanlar'],

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
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Ürünler', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Stack(
        children: [
          // Arka plan resmi
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/backproducer.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Ana içerik
          Padding(
            padding: EdgeInsets.only(top: kToolbarHeight + MediaQuery.of(context).padding.top),
            child: Column(
              children: [
                // Filtreler Container ile şeffaf ve oval
                Padding(
                  padding: EdgeInsets.all(12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFF0E4C8).withOpacity(0.9), // Şeffaf renk
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String?>(
                                value: selectedCategory,
                                items: [
                                  DropdownMenuItem<String?>(
                                    value: null,
                                    child: Text('Tümü'),
                                  ),
                                  ...categoryMap.keys
                                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                      .toList(),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    selectedCategory = value;
                                    selectedSubcategory = null;
                                  });
                                },
                                decoration: InputDecoration(labelText: 'Kategori'),
                              ),
                            ),
                            SizedBox(width: 16),
                            if (selectedCategory != null)
                              Expanded(
                                child: DropdownButtonFormField<String?>(
                                  key: ValueKey(selectedCategory),
                                  value: selectedSubcategory,
                                  items: [
                                    DropdownMenuItem<String?>(
                                      value: null,
                                      child: Text('Tümü'),
                                    ),
                                    ...categoryMap[selectedCategory!]!
                                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                        .toList(),
                                  ],
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
                                  : DropdownButtonFormField<String?>(
                                value: selectedCity,
                                items: [
                                  DropdownMenuItem<String?>(
                                    value: null,
                                    child: Text('Tümü'),
                                  ),
                                  ...cities
                                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                      .toList(),
                                ],
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
                                child: DropdownButtonFormField<String?>(
                                  value: selectedDistrict,
                                  items: [
                                    DropdownMenuItem<String?>(
                                      value: null,
                                      child: Text('Tümü'),
                                    ),
                                    ...districts
                                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                        .toList(),
                                  ],
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
                    ),
                  ),
                ),

                // Liste kısmı
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
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Color(0xFFF0E4C8).withOpacity(0.9),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ListTile(
                              title: Text(ilan['altKategori'] ?? ''),
                              subtitle: Text(
                                "İl: ${ilan['il'] ?? '-'} - İlçe: ${ilan['ilce'] ?? '-'}\nFiyat: ${ilan['fiyat'] ?? '-'} ₺",
                              ),
                              isThreeLine: true,
                              trailing: IconButton(
                                icon: Icon(Icons.delete, color: Colors.black),
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text("İlanı silmek istediğinize emin misiniz?"),
                                      actions: [
                                        TextButton(
                                          child: Text("İptal"),
                                          onPressed: () => Navigator.pop(context, false),
                                        ),
                                        TextButton(
                                          child: Text("Sil"),
                                          onPressed: () => Navigator.pop(context, true),
                                        ),
                                      ],
                                    ),
                                  );

                                  if (confirm == true) {
                                    try {
                                      await FirebaseFirestore.instance
                                          .collection('ilanlar')
                                          .doc(ilan.id)
                                          .delete();

                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text("İlan silindi.")),
                                      );
                                    } catch (e) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text("İlan silinirken hata oluştu.")),
                                      );
                                    }
                                  }
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
