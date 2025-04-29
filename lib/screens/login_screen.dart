import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode usernameFocusNode = FocusNode();//bunu da klavye çin

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: true,//bunu da kalvye için keledik
      appBar: AppBar(
        title: Text("Kullanıcı Girişi"),
        backgroundColor: Color(0x846FAF37),
      ),
      backgroundColor: Color(0xFFFAF7AC), // BEYAZ DI DEGİSTİRDİM BİDAHA BAKARSIN

      body: SafeArea(//safe area ekledik klavye için
        child:SingleChildScrollView(

          child:Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 100),
                // Kullanıcı adı kısmının üstünde bir resim ekliyoruz
                Image.asset(
                  'assets/images/emmim.png',  // Burada resmin dosya yolu
                  width: 200, // Resmin genişliği
                  height: 200, // Resmin yüksekliği
                ),
                SizedBox(height: 20), // Resim ile kullanıcı adı arasındaki boşluk

                // Kullanıcı adı alanı
                TextField(

                  controller: usernameController,
                  //focusNode: usernameFocusNode, // FocusNode ekliyoruz

                  decoration: InputDecoration(
                    labelText: "Kullanıcı Adı",
                    hintText: "Kullanıcı adınızı girin",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15), // Oval köşe için
                    ),
                    prefixIcon: Icon(Icons.person),
                  ),
                  textInputAction: TextInputAction.next, // Klavye açıldığında "next" aksiyonu
                ),
                SizedBox(height: 20),

                // Şifre alanı
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Şifre",
                    hintText: "Şifrenizi girin",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15), // Oval köşe için
                    ),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  textInputAction: TextInputAction.done,//şifre girdikten sonra klavyeyi kaaptıo
                ),
                SizedBox(height: 30),

                // Giriş yap butonu
                ElevatedButton(
                  onPressed: () {
                    final username = usernameController.text;
                    final password = passwordController.text;

                    if (username.isEmpty || password.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Lütfen tüm alanları doldurun!")),
                      );
                    } else if (username == "admin" && password == "1234") {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Giriş başarılı!")),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Hatalı kullanıcı adı veya şifre!")),
                      );
                    }
                  },
                  child: Text("Giriş Yap"),
                  style:
                  ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50), // Buton genişliğini artırmak için
                    foregroundColor: Colors.black87,
                    backgroundColor: Color(0x846FAF37),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Kayıt ol butonu
                TextButton(
                  onPressed: () {
                    // Burada kayıt ol sayfasına yönlendirme yapılabilir
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
    );
  }
}

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kayıt Ol"),
        backgroundColor: Color(0x846FAF37),
      ),
      body: Center(
        child: Text("Kayıt Olma Sayfası"),
      ),
    );
  }
}
