import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  Future<void> _registerUser() async {
    setState(() => isLoading = true);
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 140),//daha sonra değiştiririz
            Image.asset(
              'assets/images/fertilizer.png',  // Burada resmin dosya yolu
              width: 200, // Resmin genişliği
              height: 200, // Resmin yüksekliği
            ),
            SizedBox(height: 30), // Resim ile kullanıcı adı arasındaki boşluk



            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: "E-mail",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            SizedBox(height: 16),
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
    );
  }
}
