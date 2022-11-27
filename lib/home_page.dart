import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qatarreciclagem/login_page.dart';
import 'package:qatarreciclagem/models/pontoOuColetor.dart';
import 'package:qatarreciclagem/notificacoes_page.dart';
import 'package:qatarreciclagem/solicitar_coleta.dart';
import 'package:qatarreciclagem/verificar_usuario.dart';
import 'package:qatarreciclagem/widgets/ColetasDisponiveis.dart';
import 'package:qatarreciclagem/widgets/ItemWidget.dart';
import 'package:qatarreciclagem/widgets/Solicitacaowidget.dart';
import 'cadastrar_editar_page.dart';
import 'coletas_pendentes.dart';
import 'models/coletasdisponiveis.dart';
import 'models/solicitacaoModel.dart';

class HomePage extends StatefulWidget {
  final bool tipoUsuarioParaDescarte;
  const HomePage({super.key, required this.tipoUsuarioParaDescarte});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    setState(() {
      widget.tipoUsuarioParaDescarte;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.tipoUsuarioParaDescarte) {
      return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CadastrarEditarPage(
                                  isEditing: true,
                                )));
                  },
                  icon: const Icon(Icons.edit)),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const NotificacoesPage(isUsuarioFinal: true),
                        ));
                  },
                  icon: const Icon(Icons.notifications)),
              IconButton(
                  onPressed: () async {
                    // atalho para o usuário deslogar do app
                    await _firebaseAuth
                        .signOut()
                        .then((value) => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const VerificarUsuarioLogado(),
                            )));
                  },
                  icon: const Icon(Icons.logout))
            ],
            backgroundColor: Colors.green,
            title: const Text("Qatar reciclagem"),
            bottom: TabBar(
              indicatorColor: Colors.white,
              tabs: [
                Container(
                  padding: const EdgeInsets.all(5),
                  child: const Text("Pontos"),
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  child: const Text("Coletores"),
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  child: const Text("Solicitações"),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              Container(
                  padding: const EdgeInsets.all(16),
                  child: StreamBuilder<List<PontoOuColetor>>(
                    stream: obterPontoColeta(),
                    builder: ((context, snapshot) {
                      if (snapshot.hasError) {
                        print(snapshot.data);
                        // se deu algum erro vai cair aqui
                        return Text("Ocorreu um erro: ${snapshot.error}");
                      }
                      if (snapshot.hasData) {
                        // se possuir informações na consulta do Firebase vai cair aqui
                        var docs = snapshot.data!;

                        if (docs.isEmpty) {
                          // caso vá ao Firebase, não de nenhum erro, mas não tem informações, irá cair aqui e exibir mensagem
                          return const Center(
                            child: Text("Nenhum documento encontrado!"),
                          );
                        }

                        return ListView(
                          // aqui é respnsável por exibir os cards na Home Page
                          children: docs.map(criarItens).toList(),
                        );
                      } else {
                        return const Center(
                            child:
                                CircularProgressIndicator()); // caso não caia em nenhum dos outros if's, será exibido um loading
                      }
                    }),
                  )),
              Container(
                  padding: const EdgeInsets.all(16),
                  child: StreamBuilder<List<PontoOuColetor>>(
                    stream: obterColetores(),
                    builder: ((context, snapshot) {
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
                            child: Text("Nenhum documento encontrado!"),
                          );
                        }

                        return ListView(
                          // aqui é respnsável por exibir os cards na Home Page
                          children: docs.map(criarItens).toList(),
                        );
                      } else {
                        return const Center(
                            child:
                                CircularProgressIndicator()); // caso não caia em nenhum dos outros if's, será exibido um loading
                      }
                    }),
                  )),
              Container(
                  padding: const EdgeInsets.all(16),
                  child: StreamBuilder<List<SolicitacaoModel>>(
                    stream: minhasSolicitacoes(),
                    builder: ((context, snapshot) {
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
                            child: Text("Nenhum documento encontrado!"),
                          );
                        }

                        return ListView(
                          // aqui é respnsável por exibir os cards na Home Page
                          children: docs.map(criarWidgetSolicitacoes).toList(),
                        );
                      } else {
                        return const Center(
                            child:
                                CircularProgressIndicator()); // caso não caia em nenhum dos outros if's, será exibido um loading
                      }
                    }),
                  ))
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SolicitarColetaPage(),
                  ));
            },
            backgroundColor: Colors.green,
            icon: const Icon(Icons.recycling_outlined),
            label: const Text("Solicitar coleta"),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const CadastrarEditarPage(isEditing: true),
                    ));
              },
              icon: const Icon(Icons.edit)),
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const NotificacoesPage(isUsuarioFinal: false),
                    ));
              },
              icon: const Icon(Icons.notifications)),
          IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ));
              },
              icon: const Icon(Icons.logout))
        ],
        title: const Text("Qatar Reciclagem"),
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
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.green,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) => const ColetasPendentes())));
        },
        label: const Text("Ver minhas coletas"),
      ),
    );
  }

  Widget criarItens(PontoOuColetor item) => ItemWidget(
      id: item.id,
      nome: item.nome,
      endereco: item.endereco,
      materiais: item.materiais,
      telefone: item.telefone);

  Widget widgetColetasDisponiveis(ColetasDisponiveisModel item) =>
      ColetasDisponiveisWidget(
          userId: item.userId,
          docId: item.docId,
          nome: item.nome,
          endereco: item.endereco,
          materiais: item.materiais,
          telefone: item.telefone,
          data: item.data,
          horas: item.horas);

  Widget criarWidgetSolicitacoes(SolicitacaoModel item) => SolicitacaoWidget(
        data: item.data,
        docId: item.docId,
        endereco: item.endereco,
        horas: item.horas,
        userId: item.userId,
        materiais: item.materiais,
        status: item.status,
        coletorId: item.coletorId,
      );

  Stream<List<SolicitacaoModel>> minhasSolicitacoes() =>
      FirebaseFirestore.instance
          .collection("solicitacoes")
          .where("userId", isEqualTo: _firebaseAuth.currentUser!.uid)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => SolicitacaoModel.fromJson(doc.data()))
              .toList());

  Stream<List<PontoOuColetor>> obterPontoColeta() => FirebaseFirestore.instance
      .collection("users")
      .where("tipoCadastro", isEqualTo: "Ponto de descarte")
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => PontoOuColetor.fromJson(doc.data()))
          .toList());

  Stream<List<PontoOuColetor>> obterColetores() => FirebaseFirestore.instance
      .collection("users")
      .where("tipoCadastro", isEqualTo: "Coletor(a)")
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => PontoOuColetor.fromJson(doc.data()))
          .toList());

  Stream<List<ColetasDisponiveisModel>> obterColetas() => FirebaseFirestore
      .instance
      .collection("solicitacoes")
      .where("status", isEqualTo: "pendente")
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => ColetasDisponiveisModel.fromJson(doc.data()))
          .toList());

  sair() async {
    await _firebaseAuth.signOut().then((value) => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const VerificarUsuarioLogado())));
  }
}
