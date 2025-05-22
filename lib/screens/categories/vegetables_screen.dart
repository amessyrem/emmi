import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class SebzeSahipleriEkrani extends StatefulWidget {
  final String altKategori;
  const SebzeSahipleriEkrani({Key? key, required this.altKategori}) : super(key: key);

  @override
  _SebzeSahipleriEkraniState createState() => _SebzeSahipleriEkraniState();
}

class _SebzeSahipleriEkraniState extends State<SebzeSahipleriEkrani> {
  String? selectedIl;
  String? selectedIlce;

  List<String> iller = [];
  List<String> ilceler = [];

  bool isLoadingIller = true;
  bool isLoadingIlceler = false;

  @override
  void initState() {
    super.initState();
    _fetchIller();
  }

  Future<void> _fetchIller() async {
    try {
      final response = await http.get(Uri.parse("https://turkiyeapi.dev/api/v1/provinces"));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          iller = List<String>.from(data['data'].map((il) => il['name']));
          isLoadingIller = false;
        });
      } else {
        setState(() {
          isLoadingIller = false;
        });
        debugPrint("İller API hatası: ${response.statusCode}");
      }
    } catch (e) {
      setState(() {
        isLoadingIller = false;
      });
      debugPrint("İller çekme hatası: $e");
    }
  }

  Future<void> _fetchIlceler(String ilAdi) async {
    setState(() {
      isLoadingIlceler = true;
      ilceler = [];
    });
    try {
      final response = await http.get(Uri.parse("https://turkiyeapi.dev/api/v1/provinces"));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final il = data['data'].firstWhere((il) => il['name'] == ilAdi, orElse: () => null);
        if (il != null) {
          setState(() {
            ilceler = List<String>.from(il['districts'].map((d) => d['name']));
            isLoadingIlceler = false;
          });
        } else {
          setState(() {
            ilceler = [];
            isLoadingIlceler = false;
          });
        }
      } else {
        setState(() {
          ilceler = [];
          isLoadingIlceler = false;
        });
        debugPrint("İlçeler API hatası: ${response.statusCode}");
      }
    } catch (e) {
      setState(() {
        ilceler = [];
        isLoadingIlceler = false;
      });
      debugPrint("İlçeler çekme hatası: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    Query ilanQuery = FirebaseFirestore.instance
        .collection('ilanlar')
        .where('kategori', isEqualTo: "Sebze")
        .where('altKategori', isEqualTo: widget.altKategori.toLowerCase());

    if (selectedIl != null && selectedIl!.isNotEmpty) {
      ilanQuery = ilanQuery.where('il', isEqualTo: selectedIl);
    }

    if (selectedIlce != null && selectedIlce!.isNotEmpty) {
      ilanQuery = ilanQuery.where('ilce', isEqualTo: selectedIlce);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.altKategori} İçin İlan Verenler"),
        backgroundColor: const Color(0xFF0D5944),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // İl Dropdown
                Expanded(
                  child: isLoadingIller
                      ? const Center(child: CircularProgressIndicator())
                      : DropdownButton<String>(
                    hint: const Text("İl Seçiniz"),
                    value: selectedIl,
                    isExpanded: true,
                    items: [null, ...iller].map((il) {
                      return DropdownMenuItem<String>(
                        value: il,
                        child: Text(il ?? "Tüm İller"),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedIl = value;
                        selectedIlce = null;
                        ilceler = [];
                      });
                      if (value != null) {
                        _fetchIlceler(value);
                      }
                    },
                  ),
                ),

                const SizedBox(width: 16), // Dropdownlar arasında boşluk

                // İlçe Dropdown
                Expanded(
                  child: isLoadingIlceler
                      ? const Center(child: CircularProgressIndicator())
                      : DropdownButton<String>(
                    hint: const Text("İlçe Seçiniz"),
                    value: selectedIlce,
                    isExpanded: true,
                    items: [null, ...ilceler].map((ilce) {
                      return DropdownMenuItem<String>(
                        value: ilce,
                        child: Text(ilce ?? "Tüm İlçeler"),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedIlce = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: ilanQuery.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("Bu filtrelerle ilan bulunamadı."));
                }
                final ilanlar = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: ilanlar.length,
                  itemBuilder: (context, index) {
                    final ilan = ilanlar[index];
                    final userId = ilan['userId'];
                    final aciklama = ilan['aciklama'] ?? 'Açıklama yok';

                    return FutureBuilder<Map<String, dynamic>?>(
                      future: _getUserInfo(userId),
                      builder: (context, userSnapshot) {
                        if (userSnapshot.connectionState == ConnectionState.waiting) {
                          return const ListTile(title: Text("Yükleniyor..."));
                        }
                        if (!userSnapshot.hasData || userSnapshot.data == null) {
                          return const ListTile(title: Text("Kullanıcı bilgisi bulunamadı"));
                        }
                        final user = userSnapshot.data!;
                        final isim = user['isim'];
                        final soyisim = user['soyisim'];

                        return ListTile(
                          leading: const Icon(Icons.spa, color: Colors.brown, size: 28),
                          title: Text(
                            "İLAN SAHİBİ: $isim $soyisim",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.black87,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                "AÇIKLAMA: $aciklama",
                                style: TextStyle(fontSize: 17, color: Colors.grey[700]),
                              ),
                              Text(
                                "İL: ${ilan['il'] ?? 'Bilinmiyor'}",
                                style: TextStyle(fontSize: 17, color: Colors.grey[700]),
                              ),
                              Text(
                                "İLÇE: ${ilan['ilce'] ?? 'Bilinmiyor'}",
                                style: TextStyle(fontSize: 17, color: Colors.grey[700]),
                              ),
                              Text(
                                "FİYAT: ${ilan['fiyat'] != null ? ilan['fiyat'].toString() : 'Belirtilmemiş'} ₺",
                                style: TextStyle(fontSize: 17, color: Colors.grey[700]),
                              ),
                            ],
                          ),
                        );
                      },
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

  Future<Map<String, dynamic>?> _getUserInfo(String userId) async {
    final userDoc = await FirebaseFirestore.instance.collection('kullanicilar').doc(userId).get();
    if (userDoc.exists) {
      return userDoc.data();
    }
    return null;
  }
}









class VegetablesScreen extends StatelessWidget {
  const VegetablesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> vegetables = [
      {"isim": "Patates", "resim": "assets/images/patates.png"},
      {"isim": "Domates", "resim": "assets/images/domates.png"},
      {"isim": "Patlıcan", "resim": "assets/images/patlıcan.png"},
      {"isim": "Salatalık", "resim": "assets/images/salatalık.png"},
      {"isim": "Ispanak", "resim": "assets/images/ispanak.png"},
      {"isim": "Biber", "resim": "assets/images/biber.png"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sebze Ürünleri", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF0D5944),
      ),
      backgroundColor: const Color(0xFFF1E7E4),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: vegetables.map((urun) {
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SebzeSahipleriEkrani(altKategori: urun["isim"]!),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0x106FAF37),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      urun["resim"]!,
                      height: 100,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 50),
                    Text(
                      urun["isim"]!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
