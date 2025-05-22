import 'package:flutter/material.dart';
import 'register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart';
import 'producer_screen.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode usernameFocusNode = FocusNode();//bunu da klavye çin

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: true,//bunu da kalvye için keledik
      appBar: AppBar(
        title: Text("Kullanıcı Girişi" , style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF0D5944),
      ),
      backgroundColor: Color(0xFFF1E7E4), // BEYAZ DI DEGİSTİRDİM BİDAHA BAKARSIN

      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/background.jpg',
            fit: BoxFit.cover,
          ),
          // Sayfanın geri kalan içeriği
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 100),
                    Image.asset(
                      'assets/images/emmim.png',
                      width: 200,
                      height: 200,
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        fillColor: Color(0xCDF7FFDD),
                        filled: true,
                        labelText: "E-mail",
                        hintText: "E-mail girin",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        prefixIcon: Icon(Icons.person),
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        fillColor: Color(0xCDF7FFDD),
                        filled: true,
                        labelText: "Şifre",
                        hintText: "Şifrenizi girin",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        prefixIcon: Icon(Icons.lock),
                      ),
                      textInputAction: TextInputAction.done,
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () async {
                        final username = usernameController.text.trim();
                        final password = passwordController.text;

                        if (username.isEmpty || password.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Lütfen tüm alanları doldurun!")),
                          );
                          return;
                        }

                        try {
                          await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: username,
                            password: password,
                          );
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => ProducerScreen()),
                          );
                        } on FirebaseAuthException catch (e) {
                          String message = "Bir hata oluştu.";
                          if (e.code == 'user-not-found') {
                            message = "Kullanıcı bulunamadı.";
                          } else if (e.code == 'wrong-password') {
                            message = "Hatalı şifre.";
                          }
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
                        }
                      },
                      child: Text("Giriş Yap"),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                        foregroundColor: Colors.white,
                        backgroundColor: Color(0xFF0D5944),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RegisterScreen()),
                        );
                      },
                      child: Text(
                        "Hesabınız yok mu? Kayıt Ol",
                        style: TextStyle(color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
