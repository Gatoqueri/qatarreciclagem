import 'package:flutter/material.dart';
import 'package:qatarreciclagem/login_page.dart';
import 'package:qatarreciclagem/verificar_usuario.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Stack(
        children: [
          const Positioned(
            top: 30,
            left: 10,
            child: Icon(
              Icons.recycling,
              size: 80,
              color: Colors.white,
            ),
          ),
          const Positioned(
            bottom: 30,
            right: 10,
            child: Icon(
              Icons.recycling,
              size: 80,
              color: Colors.white,
            ),
          ),
          Center(
              child: Container(
            alignment: Alignment.center,
            height: 150,
            width: 200,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 5),
                borderRadius: BorderRadius.circular(16)),
            child: const Text(
              "Qatar\nReciclagem",
              style: TextStyle(color: Colors.white, fontSize: 30),
              textAlign: TextAlign.center,
            ),
          )),
        ],
      ),
    );
  }

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3))
        .then((value) => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const VerificarUsuarioLogado(),
            )));
    super.initState();
  }
}
