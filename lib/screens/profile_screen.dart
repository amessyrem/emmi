import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback? onClose;

  const ProfileScreen({this.onClose});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  bool _isPasswordVisible = false;

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserData() {
    return FirebaseFirestore.instance.collection('kullanicilar').doc(user!.uid).get();
  }

  Widget buildInfoBox(String label, String value, {bool isPassword = false}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 2))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "$label: ",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 16),
                  ),
                  TextSpan(
                    text: isPassword && !_isPasswordVisible ? "********" : value,
                    style: TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          if (isPassword)
            IconButton(
              icon: Icon(_isPasswordVisible ? Icons.visibility_off : Icons.visibility, color: Colors.grey[600]),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Profilim', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (widget.onClose != null) {
              widget.onClose!();
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: Stack(
        children: [
          // Arka plan resmi full screen
          Positioned.fill(
            child: Image.asset(
              'assets/images/backproducer.png',
              fit: BoxFit.cover,
            ),
          ),

          // Üstüne siyah yarı saydam filtre
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),

          // İçerik, SafeArea ile status bar ve çentik bölgesine saygı gösterir
          SafeArea(
            child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              future: getUserData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(child: CircularProgressIndicator());

                if (snapshot.hasError)
                  return Center(child: Text("Bir hata oluştu.", style: TextStyle(color: Colors.white)));

                if (!snapshot.hasData || !snapshot.data!.exists)
                  return Center(child: Text("Kullanıcı verisi bulunamadı.", style: TextStyle(color: Colors.white)));

                var userData = snapshot.data!.data()!;

                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      SizedBox(height: kToolbarHeight + 20), // AppBar altından başlayacak şekilde boşluk
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Color(0xFF0D5944),
                        child: Icon(Icons.person, size: 80, color: Colors.white),
                      ),
                      SizedBox(height: 24),
                      buildInfoBox("İsim", userData['isim'] ?? "Bilgi yok"),
                      buildInfoBox("Soyisim", userData['soyisim'] ?? "Bilgi yok"),
                      buildInfoBox("E-mail", userData['email'] ?? "Bilgi yok"),
                      buildInfoBox(
                        "Şifre",
                        userData.containsKey('sifre') ? userData['sifre'] : "********",
                        isPassword: true,
                      ),
                      SizedBox(height: 20), // Alt boşluk
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
