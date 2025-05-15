import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'ilan_ekle_screen.dart'; // Yeni ilan ekranı
//import 'ilanlarim_screen.dart'; // Kullanıcının ilanları listelenecek
import 'home_screen.dart';
import 'products_screen.dart';
import 'new_products_screen.dart';
import 'profile_screen.dart';



class ProducerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Üretici Paneli"),
        backgroundColor: Colors.lightGreen,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilEkrani()),
              );
            },
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
                      icon: Icon(Icons.list , size:30 , color:Colors.black, ),
                      label: Text(
                        "İlanlarım",
                        style: TextStyle(
                          fontSize: 27, // yazı boyutu
                          color:Colors.black,
                        ),
                      ),
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
                    SizedBox(height: 35),
                    ElevatedButton.icon(
                      icon: Icon(Icons.add , size:30 , color:Colors.black,),
                      label: Text("Yeni İlan Ekle" , style: TextStyle(
                        fontSize: 24, color:Colors.black,// yazı boyutu
                      ),),
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
