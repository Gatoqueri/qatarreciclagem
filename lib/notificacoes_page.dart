import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qatarreciclagem/models/notificacoes_model.dart';
import 'package:qatarreciclagem/widgets/notificacoeswidget.dart';

class NotificacoesPage extends StatelessWidget {
  final bool isUsuarioFinal;
  const NotificacoesPage({super.key, required this.isUsuarioFinal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notificações"),
        backgroundColor: Colors.green,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: StreamBuilder<List<NotificacaoModel>>(
              stream: obterNotificacoes(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  // se deu algum erro vai cair aqui
                  return Text("Ocorreu um erro: ${snapshot.error}");
                }
                if (snapshot.hasData) {
                  // se possuir informações na consulta do Firebase vai cair aqui
                  var docs = snapshot.data!;

                  if (docs.isEmpty) {
                    // caso vá ao Firebase, não de nenhum erro, mas não tem informações, irá cair aqui e exibir mensagem
                    return const Center(
                      child: Text("Nenhuma notificação encontrada!"),
                    );
                  }

                  return ListView(
                    // aqui é respnsável por exibir os cards na Home Page
                    children: docs.map(widgetNotificacoes).toList(),
                  );
                } else {
                  return const CircularProgressIndicator(); // caso não caia em nenhum dos outros if's, será exibido um loading
                }
              }),
        ),
      ),
    );
  }

  Widget widgetNotificacoes(NotificacaoModel item) => NotificacoesWidget(
        isUsuarioFinal: isUsuarioFinal,
        mensagem: item.mensagem,
        notificacaoId: item.notificacaoId,
        coletor: item.coletor,
        coletorId: item.coletorId,
      );

  Stream<List<NotificacaoModel>> obterNotificacoes() =>
      FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("notificacoes")
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => NotificacaoModel.fromJson(doc.data()))
              .toList());
}
