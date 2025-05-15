import 'package:flutter/material.dart';

class ProfilEkrani extends StatefulWidget {
  @override
  _ProfilEkraniState createState() => _ProfilEkraniState();
}

class _ProfilEkraniState extends State<ProfilEkrani> {
  TextEditingController emailController = TextEditingController();
  TextEditingController telefonController = TextEditingController();

  String guncelEmail = '';
  String guncelTelefon = '';

  void bilgileriKaydet() {
    setState(() {
      guncelEmail = emailController.text;
      guncelTelefon = telefonController.text;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Bilgiler başarıyla güncellendi."),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[100],
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("Profilim"),
        leading: const BackButton(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          children: [
            // Profil fotoğrafı
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage("assets/images/farmer2.png"),
              ),
            ),
            const SizedBox(height: 16),

            // Ad Soyad
            Center(
              child: Text(
                "Ad Soyad",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // E-posta giriş alanı
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: "E-posta",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),

            // Telefon giriş alanı
            TextField(
              controller: telefonController,
              decoration: InputDecoration(
                labelText: "Telefon",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 30),

            // Kaydet butonu
            ElevatedButton.icon(
              onPressed: bilgileriKaydet,
              icon: Icon(Icons.save),
              label: Text("Kaydet"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),

            const SizedBox(height: 30),

            // Güncel bilgiler gösterimi
            if (guncelEmail.isNotEmpty || guncelTelefon.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Kaydedilen Bilgiler:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text("E-posta: $guncelEmail"),
                  Text("Telefon: $guncelTelefon"),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

