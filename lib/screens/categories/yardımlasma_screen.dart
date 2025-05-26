import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class YardimScreen extends StatefulWidget {
  const YardimScreen({Key? key}) : super(key: key);

  @override
  _YardimScreenState createState() => _YardimScreenState();
}

class _YardimScreenState extends State<YardimScreen> {
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
        }
      }
    } catch (e) {
      debugPrint("İlçeler çekme hatası: $e");
    } finally {
      setState(() {
        isLoadingIlceler = false;
      });
    }
  }

  Future<Map<String, dynamic>?> _getUserInfo(String userId) async {
    final userDoc = await FirebaseFirestore.instance.collection('kullanicilar').doc(userId).get();
    return userDoc.exists ? userDoc.data() : null;
  }

  @override
  Widget build(BuildContext context) {
    Query ilanQuery = FirebaseFirestore.instance
        .collection('ilanlar')
        .where('kategori', isEqualTo: "Yardımlaşma")
        .where('altKategori', isEqualTo: "ilanlar");

    if (selectedIl != null && selectedIl!.isNotEmpty) {
      ilanQuery = ilanQuery.where('il', isEqualTo: selectedIl);
    }

    if (selectedIlce != null && selectedIlce!.isNotEmpty) {
      ilanQuery = ilanQuery.where('ilce', isEqualTo: selectedIlce);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Yardımlaşma İlanları", style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/yardım.png',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              const SizedBox(height: kToolbarHeight + 40),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
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
                    const SizedBox(width: 16),
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

                    return GridView.builder(
                      padding: const EdgeInsets.all(12),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: ilanlar.length,
                      itemBuilder: (context, index) {
                        final ilan = ilanlar[index];
                        final userId = ilan['userId'];
                        final aciklama = ilan['aciklama'] ?? 'Açıklama yok';

                        return FutureBuilder<Map<String, dynamic>?>(
                          future: _getUserInfo(userId),
                          builder: (context, userSnapshot) {
                            if (userSnapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            if (!userSnapshot.hasData || userSnapshot.data == null) {
                              return const Text("Kullanıcı bulunamadı");
                            }

                            final user = userSnapshot.data!;
                            final isim = user['isim'];
                            final soyisim = user['soyisim'];

                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(2, 4),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.volunteer_activism, color: Colors.green, size: 28),
                                  const SizedBox(height: 6),
                                  Text(
                                    "$isim $soyisim",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Açıklama: $aciklama",
                                    style: const TextStyle(fontSize: 13, color: Colors.black54),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text("İl: ${ilan['il'] ?? 'Bilinmiyor'}", style: const TextStyle(fontSize: 13)),
                                  Text("İlçe: ${ilan['ilce'] ?? 'Bilinmiyor'}", style: const TextStyle(fontSize: 13)),
                                  Text(
                                    "Fiyat: ${ilan['fiyat'] != null ? ilan['fiyat'].toString() + ' ₺' : 'Belirtilmemiş'}",
                                    style: const TextStyle(fontSize: 13),
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
        ],
      ),
    );
  }
}
