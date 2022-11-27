// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'cadastrar_editar_page.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("Qatar Reciclagem"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text("Fazer login:"),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: "e-mail"),
              validator: (text) {
                if (text == null || text.isEmpty) {
                  return "O campo deve ser preenchido!";
                }

                if (!text.contains("@")) {
                  return "Insira um e-mail válido!";
                }

                return null;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _senhaController,
              obscureText: true,
              validator: (text) {
                if (text == null || text.isEmpty) {
                  return "O campo deve ser preenchido!";
                }

                if (text.length < 6) {
                  return "A senha deve ter no mínimo 6 caracteres!";
                }

                return null;
              },
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: "senha"),
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: () async {
                  FocusManager.instance.primaryFocus?.unfocus();
                  if (_formKey.currentState!.validate()) {
                    await login();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Dados inválidos!"),
                      backgroundColor: Colors.red,
                    ));
                  }
                },
                child: const Text("Entrar")),
            const SizedBox(
              height: 10,
            ),
            const Text("Não tem cadastro?"),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CadastrarEditarPage(
                          isEditing: false,
                        ),
                      ));
                },
                child: const Text(
                  "Clique aqui para se cadastrar",
                )),
          ],
        ),
      ),
    );
  }

  Future login() async {
    try {
      UserCredential user = await _firebaseAuth.signInWithEmailAndPassword(
          email: _emailController.text, password: _senhaController.text);

      if (user.user != null) {
        String tipo = "";

        var userData = FirebaseFirestore.instance
            .collection("users")
            .doc(_firebaseAuth.currentUser!.uid);
        userData.get().then((value) {
          var data = value.data();

          print(data);

          if (data != null) {
            // insere dentro do TextController os dados obtidos na chamada ao Firebase
            tipo = data["tipoCadastro"];
            print(tipo);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(
                      tipoUsuarioParaDescarte:
                          tipo == "Solicitante" ? true : false),
                ));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Ocorreu um erro ao obter informações do usuário!"),
              backgroundColor: Colors.red,
            ));
          }
        });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Usuário não encontrado!"),
          backgroundColor: Colors.red,
        ));
      } else if (e.code == "wrong-password") {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Dados incorretos, tente novamente!"),
          backgroundColor: Colors.red,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Ocorreu um erro ao realizar o login: $e"),
          backgroundColor: Colors.red,
        ));
      }
    }
  }
}
