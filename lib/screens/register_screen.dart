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
        'sifre': passwordController.text.trim(),
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
      appBar: AppBar(title: Text("Kayıt Ol" ,
        style: TextStyle(color: Color(0xFFFFFFFF)),),
          backgroundColor: Color(0xFF0D5944)),
      backgroundColor: Color(0xFFF1E7E4),
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
                  fillColor: Color(0xCDF7FFDD),
                  filled: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              SizedBox(height: 16),

              // Soyisim
              TextField(
                controller: surnameController,
                decoration: InputDecoration(
                  labelText: "Soyisim",
                  fillColor: Color(0xCDF7FFDD),
                  filled: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              SizedBox(height: 16),

              // E-mail
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "E-mail",
                  fillColor: Color(0xCDF7FFDD),
                  filled: true,
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
                  fillColor: Color(0xCDF7FFDD),
                  filled: true,
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
                  backgroundColor: Color(0xFF0D5944),
                  foregroundColor: Color(0xFFFFFFFF), // Yazı rengi burada
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
