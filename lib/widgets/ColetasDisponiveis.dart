// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ColetasDisponiveisWidget extends StatefulWidget {
  String nome;
  String endereco;
  String materiais;
  String telefone;
  String data;
  String horas;
  String userId;
  String docId;
  String? coletorId;
  bool? finalizado;

  ColetasDisponiveisWidget(
      {super.key,
      required this.userId,
      required this.docId,
      required this.nome,
      required this.endereco,
      required this.materiais,
      required this.telefone,
      this.coletorId,
      required this.data,
      required this.horas});

  @override
  State<ColetasDisponiveisWidget> createState() =>
      _ColetasDisponiveisWidgetState();
}

class _ColetasDisponiveisWidgetState extends State<ColetasDisponiveisWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 15),
        child: InkWell(
          onTap: () async {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Voltar",
                            style: TextStyle(color: Colors.grey),
                          )),
                      TextButton(
                          onPressed: () async {
                            if (widget.coletorId != null) {
                              await finalizarRecolhimento();
                            } else {
                              await confimarRecolhimento();
                            }
                          },
                          child: Text(
                            widget.coletorId != null
                                ? "Finalizar recolhimento"
                                : "Confirmar recolhimento",
                            style: const TextStyle(color: Colors.green),
                          ))
                    ],
                    content: Column(mainAxisSize: MainAxisSize.min, children: [
                      widget.coletorId == null
                          ? Text(
                              "Confirmar recolhimento do material solicitado por ${widget.nome} no dia ${widget.data} as ${widget.horas}?")
                          : const Text("Confirmar finalização da coleta?")
                    ]),
                  );
                });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      blurRadius: 3,
                      blurStyle: BlurStyle.normal,
                      offset: const Offset(1, 3),
                      color: Colors.black.withOpacity(.4),
                      spreadRadius: 2),
                ],
                border: Border.all(color: Colors.green, width: 2),
                borderRadius: const BorderRadius.all(Radius.circular(5))),
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.nome,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(widget.endereco),
                const SizedBox(
                  height: 10,
                ),
                Text("Materiais para recolher: ${widget.materiais}"),
                const SizedBox(
                  height: 10,
                ),
                Text(widget.telefone),
                const SizedBox(
                  height: 10,
                ),
                Text("Data e hora: ${widget.data} ${widget.horas}"),
              ],
            ),
          ),
        ));
  }

  finalizarRecolhimento() async {
    try {
      await FirebaseFirestore.instance
          .collection("solicitacoes")
          .doc(widget.docId)
          .update({
        "status": "finalizado",
      });

      var notificacao = FirebaseFirestore.instance
          .collection("users")
          .doc(widget.userId)
          .collection("notificacoes")
          .doc();

      await notificacao.set({
        "notificacaoId": notificacao.id,
        "coletor": FirebaseAuth.instance.currentUser!.displayName,
        "coletorId": FirebaseAuth.instance.currentUser!.uid,
        "mensagem": "Coleta finalizada"
      }).then((value) => Navigator.pop(context));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Ocorreu um erro: $e"),
      ));
    }
  }

  confimarRecolhimento() async {
    try {
      await FirebaseFirestore.instance
          .collection("solicitacoes")
          .doc(widget.docId)
          .update({
        "status": "confirmado",
        "coletorId": FirebaseAuth.instance.currentUser!.uid
      });

      var notificacao = FirebaseFirestore.instance
          .collection("users")
          .doc(widget.userId)
          .collection("notificacoes")
          .doc();

      await notificacao.set({
        "notificacaoId": notificacao.id,
        "coletor": FirebaseAuth.instance.currentUser!.displayName,
        "coletorId": FirebaseAuth.instance.currentUser!.uid,
        "mensagem": "O coletor irá recolher sua reciclagem"
      }).then((value) => Navigator.pop(context));
    } catch (e) {
      print(e);
    }
  }
}
