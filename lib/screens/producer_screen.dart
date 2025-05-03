import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'ilan_ekle_screen.dart'; // Yeni ilan ekranı
//import 'ilanlarim_screen.dart'; // Kullanıcının ilanları listelenecek
import 'home_screen.dart';
import 'products_screen.dart';
import 'new_products_screen.dart';


class ProducerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Üretici Paneli"),
        backgroundColor: Color(0x846FAF37),
        actions: [
          GestureDetector(
            onTap: () {
              // Profil sayfasına yönlendirme ya da kullanıcı çıkışı gibi işlemler yapılabilir
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Profil tıklandı")),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Image.asset(
                'assets/images/emmim.png', // Profil simgesi PNG dosyasının yolu
                width: 32,
                height: 32,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            color: Color(0xFFFAF7AC), // arka plan rengi buraya
          ),
          SafeArea(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Fazla boşluk kaplamasın
                  children: [
                    ElevatedButton.icon(
                      icon: Icon(Icons.list),
                      label: Text("İlanlarım"),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 60),
                        backgroundColor: Color(0x846FAF37),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyProductsScreen()),
                        );
                      },
                    ),
                    SizedBox(height: 24),
                    ElevatedButton.icon(
                      icon: Icon(Icons.add),
                      label: Text("Yeni İlan Ekle"),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 60),
                        backgroundColor: Color(0x846FAF37),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => NewListingScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
