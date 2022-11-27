import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotificacoesWidget extends StatefulWidget {
  String? coletor;
  String coletorId;
  String mensagem;
  String notificacaoId;
  bool isUsuarioFinal;

  NotificacoesWidget(
      {super.key,
      required this.coletorId,
      required this.mensagem,
      required this.notificacaoId,
      required this.isUsuarioFinal,
      this.coletor});

  @override
  State<NotificacoesWidget> createState() => _NotificacoesWidgetState();
}

class _NotificacoesWidgetState extends State<NotificacoesWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: widget.isUsuarioFinal ? Colors.blue[50] : Colors.red[100]),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(widget.mensagem),
            ),
            IconButton(
                onPressed: () async {
                  await excluirNotificacao();
                },
                icon: const Icon(Icons.clear))
          ]),
    );
  }

  excluirNotificacao() async {
    try {
      FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("notificacoes")
          .doc(widget.notificacaoId)
          .delete();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Ocorreu um erro: $e"),
      ));
    }
  }
}
