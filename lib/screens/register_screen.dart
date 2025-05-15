import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();     // İSİM
  final TextEditingController surnameController = TextEditingController();  // SOYİSİM

  bool isLoading = false;

  Future<void> _registerUser() async {
    setState(() => isLoading = true);
    try {
      // Firebase Auth ile kullanıcı oluştur
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      User? user = userCredential.user;

      // Firestore'a kullanıcıyı ekle
      await FirebaseFirestore.instance.collection('kullanicilar').doc(user!.uid).set({
        'email': user.email,
        'isim': nameController.text.trim(),
        'soyisim': surnameController.text.trim(),
        'kayitTarihi': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Kayıt başarılı!")),
      );
      Navigator.pop(context); // Login ekranına dön
    } on FirebaseAuthException catch (e) {
      String message = "Bir hata oluştu.";
      if (e.code == 'email-already-in-use') {
        message = "Bu e-posta zaten kullanılıyor.";
      } else if (e.code == 'weak-password') {
        message = "Şifre en az 6 karakter olmalı.";
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Kayıt Ol"), backgroundColor: Color(0x846FAF37)),
      backgroundColor: Color(0xFFFAF7AC),
      body: SingleChildScrollView( // Taşmaları önlemek için
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              Image.asset(
                'assets/images/farmer2.png',
                width: 200,
                height: 200,
              ),
              SizedBox(height: 40),

              // İsim
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "İsim",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              SizedBox(height: 16),

              // Soyisim
              TextField(
                controller: surnameController,
                decoration: InputDecoration(
                  labelText: "Soyisim",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              SizedBox(height: 16),

              // E-mail
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "E-mail",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              SizedBox(height: 16),

              // Şifre
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Şifre",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              SizedBox(height: 24),

              isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _registerUser,
                child: Text("Kayıt Ol"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0x846FAF37),
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
