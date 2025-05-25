import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PhoneVerificationScreen extends StatefulWidget {
  @override
  _PhoneVerificationScreenState createState() => _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  final _phoneController = TextEditingController();
  final _smsController = TextEditingController();
  String? _verificationId;
  bool _codeSent = false;
  bool _loading = false;

  void _sendCode() async {
    setState(() => _loading = true);
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: _phoneController.text.trim(),
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Otomatik doğrulama (Android)
        await FirebaseAuth.instance.currentUser?.linkWithCredential(credential);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Telefon başarıyla doğrulandı!")));
        Navigator.pop(context);
      },
      verificationFailed: (FirebaseAuthException e) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Doğrulama başarısız: ${e.message}")));
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
          _codeSent = true;
          _loading = false;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  void _verifyCode() async {
    setState(() => _loading = true);
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: _smsController.text.trim(),
      );

      User? user = FirebaseAuth.instance.currentUser;
      await user?.linkWithCredential(credential);

      // ✅ Firestore'a telefon numarasını kaydet
      await FirebaseFirestore.instance.collection('kullanicilar').doc(user!.uid).update({
        'telefon': _phoneController.text.trim(),
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Telefon başarıyla doğrulandı!")));
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Kod doğrulanamadı: ${e.message}")));
    } finally {
      setState(() => _loading = false);
    }
  }


  @override
  void dispose() {
    _phoneController.dispose();
    _smsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Telefon Doğrulama"),
        backgroundColor: Colors.green.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (!_codeSent) ...[
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: "Telefon numarası (+90xxxxxxxxxx)",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _loading ? null : _sendCode,
                child: Text("Kod Gönder"),
              ),
            ] else ...[
              TextField(
                controller: _smsController,
                decoration: InputDecoration(
                  labelText: "Doğrulama Kodu",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _loading ? null : _verifyCode,
                child: Text("Doğrula"),
              ),
            ],
            if (_loading) CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
