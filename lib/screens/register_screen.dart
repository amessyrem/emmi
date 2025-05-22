import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'verify_mail_screen.dart';  // Dosya adı büyük/küçük harfe dikkat et (senin VerifyCodeScreen)

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

<<<<<<< HEAD
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
=======
  Future<void> _sendVerificationCode() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final name = nameController.text.trim();
    final surname = surnameController.text.trim();
>>>>>>> 11e8023 (uygulama için tasarlanan logo eklendi, sayfalarda düzenlemeler yapıldı, email doğrulama işlemine devam ediliyor.)

    if (email.isEmpty || password.isEmpty || name.isEmpty || surname.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lütfen tüm alanları doldurun')),
      );
<<<<<<< HEAD
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String message = "Bir hata oluştu.";
      if (e.code == 'email-already-in-use') {
        message = "Bu e-posta zaten kullanılıyor.";
      } else if (e.code == 'weak-password') {
        message = "Şifre en az 6 karakter olmalı.";
=======
      return;
    }

    setState(() => isLoading = true);

    final url = Uri.parse('http://10.0.2.2:5000/send_code');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Doğrulama kodu e-posta adresinize gönderildi!')),
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerifyCodeScreen(
              email: email,
              password: password,
              name: name,
              surname: surname,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Kod gönderilemedi.')),
        );
>>>>>>> 11e8023 (uygulama için tasarlanan logo eklendi, sayfalarda düzenlemeler yapıldı, email doğrulama işlemine devam ediliyor.)
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hata oluştu: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        fillColor: Color(0xCDF7FFDD),
        filled: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
<<<<<<< HEAD
        title: Text(
          "Kayıt Ol",
          style: TextStyle(color: Colors.white),
=======
        title: Text("Kayıt Ol", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF0D5944),
      ),
      backgroundColor: Color(0xFFF1E7E4),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Column(
          children: [
            SizedBox(height: 40),
            Image.asset('assets/images/farmer2.png', width: 200, height: 200),
            SizedBox(height: 40),
            _buildTextField("İsim", nameController),
            SizedBox(height: 16),
            _buildTextField("Soyisim", surnameController),
            SizedBox(height: 16),
            _buildTextField("E-mail", emailController),
            SizedBox(height: 16),
            _buildTextField("Şifre", passwordController, isPassword: true),
            SizedBox(height: 24),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _sendVerificationCode,
              child: Text("E-posta Doğrulama Kodu Gönder"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF0D5944),
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
>>>>>>> 11e8023 (uygulama için tasarlanan logo eklendi, sayfalarda düzenlemeler yapıldı, email doğrulama işlemine devam ediliyor.)
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
