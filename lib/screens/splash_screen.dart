import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';  // Lottie paketini import ettik
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    // 3 saniye sonra ana sayfaya geçiş yapıyoruz
    Future.delayed(const Duration(seconds: 7), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
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
      backgroundColor: Color(0xFFFAF7AC),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Lottie.asset('assets/animations/sepetli_dayi.json', width: 400, height: 400),  // BURDA ANİMASYONLARI SONRA SEÇERSİN
            const SizedBox(height: 20),
            const Text(
              'eMMi',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
