import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SolicitarColetaPage extends StatefulWidget {
  const SolicitarColetaPage({super.key});

  @override
  State<SolicitarColetaPage> createState() => _SolicitarColetaPageState();
}

class _SolicitarColetaPageState extends State<SolicitarColetaPage> {
  DateTime dateTime = DateTime.now();
  int? horas;
  int? minutos;
  final _materiaisController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _enderecoController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  List<String> itensSelecionados = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("Solicitar Coleta"),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                "Data do recolhimento:",
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton.icon(
                  onPressed: () async {
                    DateTime? date = await pickDate();

                    if (date == null) return;

                    setState(() {
                      dateTime = date;
                    });
                  },
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  icon: const Icon(Icons.calendar_today),
                  label: Text(
                      "${dateTime.day}/${dateTime.month}/${dateTime.year}")),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Hora aproximada do recolhimento:",
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton.icon(
                  onPressed: () async {
                    var time = await pickTime();

                    if (time == null) return;

                    setState(() {
                      horas = time.hour;
                      minutos = time.minute;
                    });
                  },
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  icon: const Icon(Icons.watch_later),
                  label: Text("${horas ?? "00"}:${minutos ?? "00"}")),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Itens para recolher:",
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _materiaisController,
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return "O campo deve ser preenchido";
                  }

                  return null;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Endereço:",
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _enderecoController,
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return "O campo deve ser preenchido";
                  }

                  return null;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Telefone de contato:",
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _telefoneController,
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return "O campo deve ser preenchido";
                  }

                  return null;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[900]),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      criarSolicitacao();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                            "Verifique os dados preenchidos e tente novamente"),
                        backgroundColor: Colors.red,
                      ));
                    }
                  },
                  child: const Text("Registrar solicitação"))
            ],
          ),
        ),
      ),
    );
  }

  criarSolicitacao() async {
    var coletaJson = {
      "userId": FirebaseAuth.instance.currentUser!.uid,
      "nome": FirebaseAuth.instance.currentUser!.displayName,
      "data": "${dateTime.day}/${dateTime.month}/${dateTime.year}",
      "horas": "$horas : $minutos",
      "materiais": _materiaisController.text,
      "endereco": _enderecoController.text,
      "telefone": _telefoneController.text,
      "status": "pendente"
    };

    try {
      var doc = FirebaseFirestore.instance.collection("solicitacoes").doc();

      doc.set(coletaJson).then((value) {
        doc.update({"docId": doc.id}).then((value) => Navigator.pop(context));
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Ocorreu um erro: $e")));
    }
  }

  Future<DateTime?> pickDate() => showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: dateTime,
      lastDate: dateTime.add(const Duration(days: 15)));

  Future<TimeOfDay?> pickTime() => showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: dateTime.hour, minute: dateTime.minute));
}
