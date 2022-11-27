import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ItemWidget extends StatefulWidget {
  String id;
  String nome;
  String endereco;
  String materiais;
  String telefone;

  ItemWidget(
      {super.key,
      required this.nome,
      required this.endereco,
      required this.materiais,
      required this.id,
      required this.telefone});

  @override
  State<ItemWidget> createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {
  copiarTelefone(String telefone) async {
    await Clipboard.setData(ClipboardData(text: telefone));

    exibirSnackBar();
  }

  exibirSnackBar() {
    const snackBar = SnackBar(
      content: Text('Copiado com sucesso!'),
      backgroundColor: Colors.green,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
          const Text(
            "Reciclagem geral",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text("Rua projetada 12, número 80, Centro"),
          const SizedBox(
            height: 10,
          ),
          const Text(
              "Materiais: papel, papelão, latas, ferros, galhos e folhas."),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const Text("(17) 98888-2222"),
              IconButton(
                  onPressed: () {
                    copiarTelefone("(17) 98888-2222");
                  },
                  icon: const Icon(Icons.copy))
            ],
          )
        ],
      ),
    );
  }
}
