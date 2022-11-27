import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SolicitacaoWidget extends StatefulWidget {
  String docId;
  String userId;
  String data;
  String horas;
  String materiais;
  String endereco;
  String status;
  String? coletorId;

  SolicitacaoWidget(
      {super.key,
      required this.docId,
      required this.userId,
      required this.data,
      required this.materiais,
      required this.status,
      required this.endereco,
      required this.horas,
      this.coletorId});

  @override
  State<SolicitacaoWidget> createState() => _SolicitacaoWidgetState();
}

class _SolicitacaoWidgetState extends State<SolicitacaoWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(color: Colors.green[50], boxShadow: [
          BoxShadow(
              offset: const Offset(1, 2),
              blurRadius: 3,
              color: Colors.black.withOpacity(.3),
              spreadRadius: 2)
        ]),
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Solicitação para o dia ${widget.data} as ${widget.horas}"),
            const SizedBox(
              height: 10,
            ),
            Text("Materiais: ${widget.materiais}"),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Status: ${widget.status}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton.icon(
                onPressed: () async {
                  await cancelarSolicitacao(widget.docId);
                },
                label: Text(
                  widget.status == "finalizado"
                      ? "Encerrar solicitação"
                      : "Cancelar solicitação",
                  style: TextStyle(
                      color: widget.status != "finalizado"
                          ? Colors.red
                          : Colors.blue),
                ),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                icon: Icon(
                  widget.status != "finalizado" ? Icons.delete : Icons.archive,
                  color:
                      widget.status != "finalizado" ? Colors.red : Colors.blue,
                ),
              ),
            )
          ],
        ));
  }

  cancelarSolicitacao(String docId) async {
    try {
      if (widget.status == "confirmado") {
        print(widget.coletorId);
        var notificacao = FirebaseFirestore.instance
            .collection("users")
            .doc(widget.coletorId)
            .collection("notificacoes")
            .doc();

        notificacao.set({
          "mensagem":
              "O usuário ${FirebaseAuth.instance.currentUser!.displayName} cancelou a solicitação de recolhimento para o dia ${widget.data} as ${widget.horas}",
          "notificacaoId": notificacao.id,
          "coletorId": widget.coletorId,
          "coletor": ""
        });

        await FirebaseFirestore.instance
            .collection("solicitacoes")
            .doc(docId)
            .delete();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Ocorreu um erro: $e"),
          backgroundColor: Colors.red,
        ));
      }
    }
  }
}
