import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController codeController = TextEditingController();

  bool _codeSent = false;
  bool _isLoading = false;

  Future<void> _sendCode() async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen e-posta giriniz')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:5000/send-code'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        setState(() {
          _codeSent = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Doğrulama kodu gönderildi. Emailinizi kontrol edin.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hata: ${data['message']}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sunucu hatası: $e')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _register() async {
    final name = nameController.text.trim();
    final surname = surnameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final code = codeController.text.trim();

    if (name.isEmpty || surname.isEmpty || email.isEmpty || password.isEmpty || code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen tüm alanları doldurun ve doğrulama kodunu girin')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final verifyResponse = await http.post(
        Uri.parse('http://10.0.2.2:5000/verify-code'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'code': code}),
      );

      final verifyData = jsonDecode(verifyResponse.body);

      if (verifyResponse.statusCode == 200 && verifyData['success'] == true) {
        final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        final uid = userCredential.user?.uid;
        if (uid != null) {
          await FirebaseFirestore.instance.collection('kullanicilar').doc(uid).set({
            'uid': uid,
            'isim': name,
            'soyisim': surname,
            'email': email,
            'sifre': password,
            'kayitTarihi': FieldValue.serverTimestamp(),
          });
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kayıt başarılı!')),
        );
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Doğrulama başarısız: ${verifyData['message']}')),
        );
      }
    } on FirebaseAuthException catch (e) {
      String message = "Bir hata oluştu.";
      if (e.code == 'email-already-in-use') {
        message = "Bu e-posta zaten kullanılıyor.";
      } else if (e.code == 'weak-password') {
        message = "Şifre en az 6 karakter olmalı.";
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kayıt hatası: $e')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kayıt Ol'),
        backgroundColor: const Color(0xFF0D5944),
      ),
      backgroundColor: const Color(0xFFF1E7E4),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                fillColor: const Color(0xCDF7FFDD),
                filled: true,
                labelText: "İsim",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: surnameController,
              decoration: InputDecoration(
                fillColor: const Color(0xCDF7FFDD),
                filled: true,
                labelText: "Soyisim",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                fillColor: const Color(0xCDF7FFDD),
                filled: true,
                labelText: "E-posta",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                fillColor: const Color(0xCDF7FFDD),
                filled: true,
                labelText: "Şifre",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
            const SizedBox(height: 16),
            if (_codeSent) ...[
              TextField(
                controller: codeController,
                decoration: InputDecoration(
                  fillColor: const Color(0xCDF7FFDD),
                  filled: true,
                  labelText: "Doğrulama Kodu",
                  hintText: "E-posta ile gelen kodu girin",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ),
              const SizedBox(height: 16),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D5944),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Kayıt Ol'),
              ),
            ] else
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _sendCode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D5944),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Doğrulama Kodu Gönder'),
              ),
          ],
        ),
      ),
    );
  }
}
