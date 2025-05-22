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
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();

  bool isLoading = false;

  Future<void> _registerUser() async {
    setState(() => isLoading = true);
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      User? user = userCredential.user;

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
      Navigator.pop(context);
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
      appBar: AppBar(
        title: Text(
          "Kayıt Ol",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF0D5944),
      ),
      backgroundColor: Color(0xFFF1E7E4),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/background.jpg',
            fit: BoxFit.cover,
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 40),
                  Image.asset(
                    'assets/images/emmim.png',
                    width: 200,
                    height: 200,
                  ),
                  SizedBox(height: 40),

                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "İsim",
                      fillColor: Color(0xCDF7FFDD),
                      filled: true,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 16),

                  TextField(
                    controller: surnameController,
                    decoration: InputDecoration(
                      labelText: "Soyisim",
                      fillColor: Color(0xCDF7FFDD),
                      filled: true,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 16),

                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "E-mail",
                      fillColor: Color(0xCDF7FFDD),
                      filled: true,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 16),

                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Şifre",
                      fillColor: Color(0xCDF7FFDD),
                      filled: true,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    textInputAction: TextInputAction.done,
                  ),
                  SizedBox(height: 24),

                  isLoading
                      ? Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                    onPressed: _registerUser,
                    child: Text("Kayıt Ol"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF0D5944),
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
