import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'products_screen.dart';
import 'new_products_screen.dart';
import 'profile_screen.dart';

class ProducerScreen extends StatefulWidget {
  @override
  _ProducerScreenState createState() => _ProducerScreenState();
}

class _ProducerScreenState extends State<ProducerScreen> with SingleTickerProviderStateMixin {
  bool _isProfilePanelVisible = false;
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(1, 0), // ekranın sağından başla
      end: Offset(0, 0),   // ekranın tam içine kaydır
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  void _toggleProfilePanel() {
    setState(() {
      _isProfilePanelVisible = !_isProfilePanelVisible;
      if (_isProfilePanelVisible) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Üretici Paneli" , style: TextStyle(color: Colors.white)),

        backgroundColor: Color(0xFF0D5944),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, color: Color(0xFFFFFFFF)),
            onPressed: _toggleProfilePanel,
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            color: Color(0xFFF1E7E4), // arka plan rengi
          ),
          SafeArea(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton.icon(
                      icon: Icon(Icons.list, size: 30, color: Colors.white),
                      label: Text(
                        "İlanlarım",
                        style: TextStyle(fontSize: 27, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 60),
                        backgroundColor: Color(0xFF0D5944),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProductFilterScreen()),
                        );
                      },
                    ),
                    SizedBox(height: 35),
                    ElevatedButton.icon(
                      icon: Icon(Icons.add, size: 30, color: Colors.white),
                      label: Text(
                        "Yeni İlan Ekle",
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 60),
                        backgroundColor: Color(0xFF0D5944),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => NewListingScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Sağdan kayan profil paneli
          if (_isProfilePanelVisible)
            SlideTransition(
              position: _slideAnimation,
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  color: Color(0xFFF1E7E4),
                  child: Column(
                    children: [
                      // Kapatma butonu
                      Container(
                        padding: EdgeInsets.only(top: 2, right: 8),
                        alignment: Alignment.topRight,
                      ),
                      Expanded(child: ProfileScreen(onClose: _toggleProfilePanel)),
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
