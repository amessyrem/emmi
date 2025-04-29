import 'package:flutter/material.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'detail_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  final List<String> boxNames = [
    'Bakliyat',
    'Hayvansal Ürünler',
    'Kuruyemiş',
    'Meyve',
    'Sebze',
    'Tüm Ürünler',
  ];

  final List<String> boxImages = [
    'assets/images/legumes.png',
    'assets/images/cow.png',
    'assets/images/nuts.png',
    'assets/images/fruit.png',
    'assets/images/vegetables.png',
    'assets/images/all.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('eMMi'), backgroundColor: Color(0x846FAF37)),
      backgroundColor: Color(0xFFFAF7AC),
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DetailScreen(index: index + 1, name: boxNames[index]),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color(0x106FAF37),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            boxImages[index],
                            width : 80,
                            height: 80,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(height: 20),
                          Text(
                            boxNames[index],
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
            icon: Icon(Icons.login,color: Colors.black,),
            label: Text("Üretici Girişi"),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: Color(0x846FAF37),
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
