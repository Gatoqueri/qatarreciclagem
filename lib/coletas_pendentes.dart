import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:qatarreciclagem/widgets/ColetasDisponiveis.dart';

import 'models/coletasdisponiveis.dart';

class ColetasPendentes extends StatefulWidget {
  const ColetasPendentes({super.key});

  @override
  State<ColetasPendentes> createState() => _ColetasPendentesState();
}

class _ColetasPendentesState extends State<ColetasPendentes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("Coletas pendentes"),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder<List<ColetasDisponiveisModel>>(
            stream: obterColetas(),
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
                    child: Text("Nenhuma solicitação encontrada!"),
                  );
                }

                return ListView(
                  // aqui é respnsável por exibir os cards na Home Page
                  children: docs.map(widgetColetasDisponiveis).toList(),
                );
              } else {
                return const CircularProgressIndicator(); // caso não caia em nenhum dos outros if's, será exibido um loading
              }
            }),
      ),
    );
  }

  Widget widgetColetasDisponiveis(ColetasDisponiveisModel item) =>
      ColetasDisponiveisWidget(
          userId: item.userId,
          docId: item.docId,
          nome: item.nome,
          endereco: item.endereco,
          materiais: item.materiais,
          telefone: item.telefone,
          data: item.data,
          coletorId: item.coletorId,
          horas: item.horas);

  Stream<List<ColetasDisponiveisModel>> obterColetas() => FirebaseFirestore
      .instance
      .collection("solicitacoes")
      .where("coletorId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .where("status", isEqualTo: "confirmado")
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => ColetasDisponiveisModel.fromJson(doc.data()))
          .toList());
}
