import 'package:flutter/material.dart';
import 'filtered_products_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ürün Filtrele'), backgroundColor: Color(0xFF0D5944)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
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
            if (selectedCategory != null)
              DropdownButtonFormField<String>(
                key: ValueKey(selectedCategory), // Bu, yeniden oluşturmayı garanti eder
                value: selectedSubcategory,
                items: categoryMap[selectedCategory!]!
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) => setState(() => selectedSubcategory = value),
                decoration: InputDecoration(labelText: 'Alt Kategori'),
              ),
            SizedBox(height: 16),
            isLoadingCities
                ? CircularProgressIndicator()
                : DropdownButtonFormField<String>(
              value: selectedCity,
              items: cities.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (value) async {
                setState(() {
                  selectedCity = value;
                  selectedDistrict = null;
                });
                await loadDistricts(value!);
              },
              decoration: InputDecoration(labelText: 'İl'),
            ),
            if (selectedCity != null && !isLoadingDistricts)
              DropdownButtonFormField<String>(
                value: selectedDistrict,
                items: districts.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (value) => setState(() => selectedDistrict = value),
                decoration: InputDecoration(labelText: 'İlçe'),
              ),
            Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF0D5944)),
              onPressed: (selectedCategory != null &&
                  selectedSubcategory != null &&
                  selectedCity != null &&
                  selectedDistrict != null)
                  ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FilteredProductsScreen(
                      kategori: selectedCategory!,
                      altKategori: selectedSubcategory!,
                      il: selectedCity!,
                      ilce: selectedDistrict!,
                    ),
                  ),
                );
              }
                  : null,
              child: Text('Ürünleri Listele', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
