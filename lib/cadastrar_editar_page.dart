// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';

class CadastrarEditarPage extends StatefulWidget {
  final bool isEditing;
  const CadastrarEditarPage({super.key, required this.isEditing});

  @override
  State<CadastrarEditarPage> createState() => _CadastrarEditarPageState();
}

class _CadastrarEditarPageState extends State<CadastrarEditarPage> {
  @override
  void initState() {
    if (widget.isEditing) {
      obterUsuario();
    }
    super.initState();
  }

  String tipoCadastro = "Solicitante";
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _horarioColeta = TextEditingController();
  final TextEditingController _materiaisRecolhidos = TextEditingController();
  final TextEditingController _enderecoRecolhidos = TextEditingController();
  final _firebaseAuth = FirebaseAuth.instance;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.isEditing ? "Editar dados" : "Cadastrar"),
        backgroundColor: Colors.green,
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Theme(
              data: Theme.of(context).copyWith(
                  unselectedWidgetColor: Colors.blueGrey,
                  disabledColor: Colors.blue,
                  indicatorColor: Colors.green),
              child: Form(
                key: _formKey,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: ListView(
                    children: [
                      TextFormField(
                        controller: _nomeController,
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return "O campo ?? obrigat??rio!";
                          }

                          if (text.length < 3) {
                            return "O nome precisa ter mais de 3 caracteres!";
                          }

                          return null;
                        },
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(), hintText: "Nome"),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _emailController,
                        enabled: !widget.isEditing,
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return "O campo ?? obrigat??rio!";
                          }

                          if (!text.contains("@")) {
                            return "Insira um e-mail v??lido!";
                          }

                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(), hintText: "E-mail"),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      widget.isEditing
                          ? Container()
                          : TextFormField(
                              controller: _senhaController,
                              obscureText: true,
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return "O campo ?? obrigat??rio!";
                                }

                                if (text.length < 6) {
                                  return "A senha precisa ter no m??nimo 6 caracteres";
                                }

                                return null;
                              },
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Senha"),
                            ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _telefoneController,
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return "O campo ?? obrigat??rio!";
                          }

                          return null;
                        },
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(), hintText: "Telefone"),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      widget.isEditing && tipoCadastro != "Solicitante"
                          ? Container()
                          : Row(
                              children: [
                                const Text("Preciso fazer um descarte"),
                                Radio(
                                    key: Key(DateTime.now.toString()),
                                    value: "Solicitante",
                                    activeColor: Colors.green,
                                    groupValue: tipoCadastro,
                                    toggleable: true,
                                    onChanged: (value) {
                                      setState(() {
                                        tipoCadastro = value ?? "Solicitante";
                                      });
                                    }),
                              ],
                            ),
                      widget.isEditing && tipoCadastro != "Coletor(a)"
                          ? Container()
                          : Row(
                              children: [
                                const Text("Sou um coletor"),
                                Radio(
                                    key: Key(DateTime.now.toString()),
                                    value: "Coletor(a)",
                                    toggleable: true,
                                    activeColor: Colors.green,
                                    groupValue: tipoCadastro,
                                    onChanged: (value) {
                                      setState(() {
                                        tipoCadastro = value ?? "Solicitante";
                                      });
                                    }),
                              ],
                            ),
                      widget.isEditing && tipoCadastro != "Ponto de descarte"
                          ? Container()
                          : Row(
                              children: [
                                const Text("Sou ponto descarte"),
                                Radio(
                                    groupValue: tipoCadastro,
                                    value: "Ponto de descarte",
                                    activeColor: Colors.green,
                                    onChanged: (value) {
                                      setState(() {
                                        tipoCadastro = value ?? "Solicitante";
                                      });
                                    }),
                              ],
                            ),
                      const SizedBox(
                        height: 10,
                      ),
                      tipoCadastro == "Coletor(a)"
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: TextFormField(
                                controller: _horarioColeta,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: "Hor??rio de recolhimento"),
                              ),
                            )
                          : tipoCadastro == "Ponto de descarte"
                              ? Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: TextFormField(
                                    controller: _horarioColeta,
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: "Hor??rio de funcionamento"),
                                  ),
                                )
                              : Container(),
                      tipoCadastro != "Solicitante"
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: TextFormField(
                                controller: _materiaisRecolhidos,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: "Materiais recolhidos"),
                              ),
                            )
                          : Container(),
                      tipoCadastro != "Solicitante"
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: TextFormField(
                                controller: _enderecoRecolhidos,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: "Endere??o"),
                              ),
                            )
                          : Container(),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green),
                          onPressed: () async {
                            FocusManager.instance.primaryFocus?.unfocus();
                            if (_formKey.currentState!.validate()) {
                              await cadastrarUsuario();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "Valide os dados e tente novamente")));
                            }
                          },
                          child: Text(
                              widget.isEditing ? "Atualizar" : "Cadastrar"))
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  cadastrarUsuario() async {
    Map<String, dynamic> userJson = {
      "nome": _nomeController.text,
      "email": _emailController.text,
      "telefone": _telefoneController.text,
      "tipoCadastro": tipoCadastro,
      "horarioColeta": _horarioColeta.text,
      "endereco": _enderecoRecolhidos.text,
      "materiaisRecolhidos": _materiaisRecolhidos.text
    };

    try {
      setState(() {
        loading = true;
      });

      if (widget.isEditing) {
        // se for uma edi????o, ir?? atualizar os dados do usu??rio
        final docUser = FirebaseFirestore.instance
            .collection("users")
            .doc(_firebaseAuth.currentUser?.uid);

        await docUser.update(userJson).then((value) =>
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Usu??rio atualizado com sucesso!"),
              backgroundColor: Colors.green,
            )));
      } else {
        print("criar usuario");
        UserCredential user =
            await _firebaseAuth.createUserWithEmailAndPassword(
                email: _emailController.text, password: _senhaController.text);

        // ap??s criado, ser?? feita a busca e inser????o dos dados em um novo documento
        final docUser =
            FirebaseFirestore.instance.collection("users").doc(user.user?.uid);

        userJson.addAll({"id": user.user?.uid});

        if (user.user != null) {
          user.user?.updateDisplayName(_nomeController.text);

          await docUser.set(userJson);

          // essa fun????o nativa do Flutter pula para pr??xima tela e impede o usu??rio de retornar para a anterior
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(
                    tipoUsuarioParaDescarte:
                        tipoCadastro == "Solicitante" ? true : false),
              ),
              (route) => false);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Ocorreu um erro ao criar os dados do usu??rio."),
              backgroundColor: Colors.red));
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "weak-password") {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Senha muito fraco, tente uma senha mais forte"),
            backgroundColor: Colors.red));
      } else if (e.code == "email-already-in-use") {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("E-mail j?? est?? em uso! Tente outro e-mail."),
          backgroundColor: Colors.red,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Erro ao se cadastrar: $e"),
          backgroundColor: Colors.red,
        ));
      }
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  // essa fun????o vai no Firebase e captura os dados do usu??rio para que sejam inseridos nos inputs e a imagem, isso s?? acontece quando for uma edi????o
  obterUsuario() async {
    setState(() => {loading = true});

    print("here");

    try {
      // passa para o Firebase o uid do usu??rio logado
      var userData = FirebaseFirestore.instance
          .collection("users")
          .doc(_firebaseAuth.currentUser!.uid);
      userData.get().then((value) {
        var data = value.data();

        if (data != null) {
          // insere dentro do TextController os dados obtidos na chamada ao Firebase
          _telefoneController.text = data["telefone"];
          _nomeController.text = data["nome"];
          _horarioColeta.text = data["horarioColeta"];
          _materiaisRecolhidos.text = data["materiaisRecolhidos"];
          _emailController.text = data["email"];
          _enderecoRecolhidos.text = data["endereco"];

          if (data["id"] == null) {
            userData.set({"id": _firebaseAuth.currentUser!.uid});
          }

          setState(() {
            tipoCadastro = data["tipoCadastro"];
            loading = false;
          });
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Ocorreu um erro: $e"),
        backgroundColor: Colors.red,
      ));
    } finally {
      setState(() => {loading = false});
    }
  }
}
