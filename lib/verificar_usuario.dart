import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qatarreciclagem/home_page.dart';
import 'package:qatarreciclagem/login_page.dart';
import 'package:qatarreciclagem/splash_screen.dart';

class VerificarUsuarioLogado extends StatefulWidget {
  const VerificarUsuarioLogado({super.key});

  @override
  State<VerificarUsuarioLogado> createState() => _VerificarUsuarioLogadoState();
}

class _VerificarUsuarioLogadoState extends State<VerificarUsuarioLogado> {
  // essa Stream é utilizada para acompanhar o que está acontecendo com o usuário e ela é cancelada quando esse widget da um dispose
  StreamSubscription? streamSubscription;

  @override
  void dispose() {
    streamSubscription?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    streamSubscription =
        FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginPage()));
      } else {
        String tipo = "";

        var userData =
            FirebaseFirestore.instance.collection("users").doc(user.uid);
        userData.get().then((value) {
          var data = value.data();

          if (data != null) {
            // insere dentro do TextController os dados obtidos na chamada ao Firebase
            tipo = data["tipoCadastro"];

            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => HomePage(
                          tipoUsuarioParaDescarte:
                              tipo == "Solicitante" ? true : false,
                        )));
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
