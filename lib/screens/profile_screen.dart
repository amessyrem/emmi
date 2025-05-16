import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  bool _isPasswordVisible = false;

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserData() {
    return FirebaseFirestore.instance
        .collection('kullanicilar')
        .doc(user!.uid)
        .get();
  }

  Widget buildInfoBox(String label, String value, {bool isPassword = false}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
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
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontSize: 16,
                    ),
                  ),
                  TextSpan(
                    text: isPassword && !_isPasswordVisible ? "********" : value,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isPassword)
            IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey[600],
              ),
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
      appBar: AppBar(
        title: Text("Profilim" , style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF0D5944),
      ),
      backgroundColor: Color(0xFFF1E7E4),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());

          if (snapshot.hasError)
            return Center(child: Text("Bir hata oluştu."));

          if (!snapshot.hasData || !snapshot.data!.exists)
            return Center(child: Text("Kullanıcı verisi bulunamadı."));

          var userData = snapshot.data!.data()!;

          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Color(0xFF0D5944),
                  child: Icon(
                    Icons.person,
                    size: 80,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 24),
                buildInfoBox("İsim", userData['isim'] ?? "Bilgi yok"),
                buildInfoBox("Soyisim", userData['soyisim'] ?? "Bilgi yok"),
                buildInfoBox("E-mail", userData['email'] ?? "Bilgi yok"),
                buildInfoBox("Şifre", userData['sifre'] ?? "********", isPassword: true),
              ],
            ),
          );
        },
      ),
    );
  }
}
