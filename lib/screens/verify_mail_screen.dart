import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String email;
  final String password;
  final String name;
  final String surname;

  const VerifyCodeScreen({
    required this.email,
    required this.password,
    required this.name,
    required this.surname,
  });

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final TextEditingController codeController = TextEditingController();
  bool isVerifying = false;

  Future<void> _verifyCodeAndRegister() async {
    setState(() => isVerifying = true);
    final code = codeController.text.trim();
    final url = Uri.parse('http://10.0.2.2:5000/verify_code');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': widget.email,
          'code': code,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        try {
          // Firebase Authentication ile kullanıcı oluştur
          UserCredential userCredential = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
            email: widget.email,
            password: widget.password,
          );

          User? user = userCredential.user;

          // Firestore'a kullanıcı bilgilerini kaydet
          if (user != null) {
            await FirebaseFirestore.instance
                .collection('kullanicilar')
                .doc(user.uid)
                .set({
              'email': user.email,
              'isim': widget.name,
              'soyisim': widget.surname,
              'kayitTarihi': FieldValue.serverTimestamp(),
            });
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Kayıt başarılı!')),
          );

          Navigator.of(context).popUntil((route) => route.isFirst);
        } on FirebaseAuthException catch (e) {
          String errorMessage = 'Kayıt başarısız: ${e.message}';
          if (e.code == 'email-already-in-use') {
            errorMessage = 'Bu e-posta adresi zaten kullanılıyor.';
          } else if (e.code == 'weak-password') {
            errorMessage = 'Şifre çok zayıf.';
          } else if (e.code == 'invalid-email') {
            errorMessage = 'Geçersiz e-posta adresi.';
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Kod doğrulanamadı.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hata: $e')),
      );
    } finally {
      setState(() => isVerifying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doğrulama Kodu'),
        backgroundColor: Color(0xFF0D5944),
      ),
      backgroundColor: Color(0xFFF1E7E4),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(height: 40),
            Text(
              'E-posta adresinize gönderilen 6 haneli kodu girin:',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            TextField(
              controller: codeController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: InputDecoration(
                labelText: 'Doğrulama Kodu',
                fillColor: Color(0xCDF7FFDD),
                filled: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            SizedBox(height: 24),
            isVerifying
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _verifyCodeAndRegister,
              child: Text("Kodu Doğrula ve Kayıt Ol"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF0D5944),
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
