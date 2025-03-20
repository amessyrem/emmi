import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'urunlerim_screen.dart';

Future<void> registerUser(String isim, String soyisim, String kullaniciAdi, String sifre, String telefon) async {
  final url = Uri.parse("http://10.0.2.2/kullanici_api/register_user.php"); // PHP dosyasının URL'si

  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "isim": isim,
      "soyisim": soyisim,
      "kullanici_adi": kullaniciAdi,
      "sifre": sifre,
      "telefon": telefon,
    }),
  );

  if (response.statusCode == 200) {
    final responseData = jsonDecode(response.body);
    if (responseData["success"]) {
      print("Kayıt başarılı: ${responseData["message"]}");
    } else {
      print("Hata: ${responseData["message"]}");
    }
  } else {
    print("Sunucu hatası: ${response.statusCode}");
  }
}


Future<void> loginUser(String kullaniciAdi, String sifre, BuildContext context) async {
  final url = Uri.parse("http://10.0.2.2/kullanici_api/login_user.php");

  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "kullanici_adi": kullaniciAdi,
      "sifre": sifre,
    }),
  );

  if (response.statusCode == 200) {
    final responseData = jsonDecode(response.body);
    if (responseData["success"]) {
      print("Giriş başarılı: ${responseData["message"]}");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      print("Hata: ${responseData["message"]}");
    }
  } else {
    print("Sunucu hatası: ${response.statusCode}");
  }
}





void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final List<String> boxNames = [
    'Bakliyat',
    'Hayvansal Ürünler',
    'Kuruyemiş',
    'Meyve',
    'Sebze',
    'Tüm Ürünler',
  ];

  final List<IconData> boxIcons = [
    Icons.grain,
    FontAwesomeIcons.cow,
    Icons.nature,
    Icons.apple,
    Icons.local_florist,
    Icons.list,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('eMMi'),
        backgroundColor: Color(0xA977DD77),
      ),
      backgroundColor: Color(0xFFFBF893),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 30,
                  mainAxisSpacing: 30,
                  childAspectRatio: 1,
                ),
                itemCount: boxNames.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      if (boxNames[index] == "Meyve") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FruitScreen()),
                        );
                      } else if (boxNames[index] == "Bakliyat") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LegumesScreen()),
                        );
                      } else if (boxNames[index] == "Hayvansal Ürünler") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AnimalProductsScreen()),
                        );
                      } else if (boxNames[index] == "Kuruyemiş") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => NutsScreen()),
                        );
                      } else if (boxNames[index] == "Sebze") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => VegetableScreen()),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AllProductsScreen(),
                          ),
                        );
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color(0x846FAF37),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            boxIcons[index],
                            size: 80,
                            color: Colors.green,
                          ),
                          SizedBox(height: 20),
                          Text(
                            boxNames[index],
                            style: TextStyle(fontSize: 16, color: Color(0xFF147E14)),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(vertical: 7, horizontal: 20),
              ),
              child: Text(
                'Üretici Girişi',
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FruitScreen extends StatelessWidget {
  final List<String> fruits = [
    'Elma', 'Portakal', 'Üzüm', 'Karpuz'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Meyveler")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 30,
            mainAxisSpacing: 30,
            childAspectRatio: 1,
          ),
          itemCount: fruits.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                print("${fruits[index]} seçildi");
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0x846FAF37),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    fruits[index],
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class LegumesScreen extends StatelessWidget {
  final List<String> legumes = ["Mercimek", "Nohut", "Fasulye", "Kuru Soğan"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bakliyat")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 30,
            mainAxisSpacing: 30,
            childAspectRatio: 1,
          ),
          itemCount: legumes.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                print("${legumes[index]} seçildi");
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0x846FAF37),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    legumes[index],
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class AnimalProductsScreen extends StatelessWidget {
  final List<String> animalProducts = ["Süt", "Yumurta", "Peynir", "Yoğurt"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Hayvansal Ürünler")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 30,
            mainAxisSpacing: 30,
            childAspectRatio: 1,
          ),
          itemCount: animalProducts.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                print("${animalProducts[index]} seçildi");
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0x846FAF37),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    animalProducts[index],
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class NutsScreen extends StatelessWidget {
  final List<String> nuts = ["Fındık", "Ceviz", "Badem", "Fıstık"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Kuruyemiş")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 30,
            mainAxisSpacing: 30,
            childAspectRatio: 1,
          ),
          itemCount: nuts.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                print("${nuts[index]} seçildi");
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0x846FAF37),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    nuts[index],
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class VegetableScreen extends StatelessWidget {
  final List<String> vegetables = ["Domates", "Patates", "Biber", "Salatalık"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sebzeler")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 30,
            mainAxisSpacing: 30,
            childAspectRatio: 1,
          ),
          itemCount: vegetables.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                print("${vegetables[index]} seçildi");
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0x846FAF37),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    vegetables[index],
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class AllProductsScreen extends StatelessWidget {
  final List<String> allProducts = [
    'Elma', 'Portakal', 'Üzüm', 'Karpuz', 'Mercimek', 'Nohut', 'Fasulye', 'Bulgur',
    'Süt', 'Peynir', 'Yoğurt', 'Yumurta', 'Bal','Fındık', 'Fıstık', 'Badem', 'Ceviz',
    'Domates', 'Salatalık', 'Biber', 'Patlıcan', 'Soğan'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tüm Ürünler")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 30,
            mainAxisSpacing: 30,
            childAspectRatio: 1,
          ),
          itemCount: allProducts.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                print("${allProducts[index]} seçildi");
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0x846FAF37),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    allProducts[index],
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Üye Girişi"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Kullanıcı Adı",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                hintText: 'Kullanıcı Adınızı Girin',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(10),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Şifre",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Şifrenizi Girin',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(10),
              ),
            ),
            SizedBox(height: 30),


            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Kullanıcı adı ve şifre giriş alanları...
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    loginUser(usernameController.text, passwordController.text, context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: Text(
                    'Giriş Yap',
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                ),
                SizedBox(height: 10), // Butonlar arasına boşluk ekleyelim
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterScreen()),
                      );
                    },
                    child: Text(
                      "Üye değil misiniz? Üye Ol",
                      style: TextStyle(fontSize: 18, color: Colors.blue),
                    ),
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}


class RegisterScreen extends StatelessWidget {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Üye Ol"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "İsim/Soyisim",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: fullNameController,
              decoration: InputDecoration(
                hintText: 'İsminizi ve soyisminizi giriniz',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(10),
              ),
            ),
            SizedBox(height: 20),

            Text(
              "Telefon Numarası",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: phoneController, // Telefon numarası için bir controller eklemeniz gerekecek
              decoration: InputDecoration(
                hintText: 'Telefon Numaranızı Girin',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(10),
              ),
            ),


            Text(
              "Kullanıcı Adı",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                hintText: 'Kullanıcı Adınızı Girin',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(10),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Şifre",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Şifrenizi Girin',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(10),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Buraya üye kaydı işlemi yapılacak kodu ekleyebilirsiniz.
                print("Üye Kaydı Yapılıyor...");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
              child: Text(
                'Üye Ol',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}