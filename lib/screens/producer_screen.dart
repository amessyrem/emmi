import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'profile_screen.dart';
import 'products_screen.dart';
import 'new_products_screen.dart';

class ProducerScreen extends StatefulWidget {
  @override
  _ProducerScreenState createState() => _ProducerScreenState();
}

class _ProducerScreenState extends State<ProducerScreen> {
  String username = "User";  // varsayılan isim
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _fetchUsername();
  }

  Future<void> _fetchUsername() async {
    if (user == null) return;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('kullanicilar')
          .doc(user!.uid)
          .get();

      if (doc.exists && doc.data() != null && doc.data()!.containsKey('isim')) {
        setState(() {
          username = doc.data()!['isim'];
        });
      }
    } catch (e) {
      // hata durumunda username "User" kalır
      print("Kullanıcı adı çekilemedi: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Üst yarı arka plan resmi
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.7, // ekran yüksekliğinin %50'si
            child: Image.asset(
              'assets/images/backproducer.png',
              fit: BoxFit.cover,
            ),
          ),

          // SafeArea ve üst kısım (başlık, geri butonu)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.black, size: 28),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(width: 40), // sağ boşluk
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Merhabalar, $username",
                    style: TextStyle(
                      fontSize: 50,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Alt yarı bar ve butonlar
          Positioned(
            bottom: -200, // negatif değerle biraz yukarı çıkarıyoruz
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.55, // ekranın %55'i kadar yükseklik
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFD1BD98),
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 12,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton.icon(
                    icon: Icon(Icons.list, size: 28, color: Colors.black),
                    label: Text(
                      "İlanlarım",
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 55),
                      backgroundColor: Color(0xFFF0E4C8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProductFilterScreen()),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    icon: Icon(Icons.add, size: 28, color: Colors.black),
                    label: Text(
                      "Yeni İlan Ekle",
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 55),
                      backgroundColor: Color(0xFFF0E4C8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NewListingScreen()),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    icon: Icon(Icons.account_circle, size: 28, color: Colors.black),
                    label: Text(
                      "Profilim",
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 55),
                      backgroundColor: Color(0xFFF0E4C8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(
                            onClose: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }

}
