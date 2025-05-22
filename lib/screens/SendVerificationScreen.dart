import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'verify_mail_screen.dart'; // VerifyCodeScreen dosya yolu neyse ona göre ayarla

class SendVerificationScreen extends StatefulWidget {
  final String password;
  final String name;
  final String surname;

  const SendVerificationScreen({
    required this.password,
    required this.name,
    required this.surname,
  });

  @override
  State<SendVerificationScreen> createState() => _SendVerificationScreenState();
}

class _SendVerificationScreenState extends State<SendVerificationScreen> {
  final TextEditingController emailController = TextEditingController();
  bool isSending = false;

  Future<void> _sendVerificationCode() async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lütfen e-posta adresinizi girin')),
      );
      return;
    }

    setState(() => isSending = true);

    final url = Uri.parse('http://10.0.2.2:5000/send_verification');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Doğrulama kodu gönderildi!')),
        );

        // Doğrulama kodu ekranına geçiş yapıyoruz
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerifyCodeScreen(
              email: email,
              password: widget.password,
              name: widget.name,
              surname: widget.surname,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Bir hata oluştu')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hata: $e')),
      );
    } finally {
      setState(() => isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Doğrulama Kodu Gönder')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(height: 40),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'E-posta Adresi',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 24),
            isSending
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _sendVerificationCode,
              child: Text('Kodu Gönder'),
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
