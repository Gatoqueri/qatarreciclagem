class PontoOuColetor {
  String id;
  String nome;
  String materiais;
  String telefone;
  String endereco;

  PontoOuColetor(
      {required this.id,
      required this.nome,
      required this.materiais,
      required this.endereco,
      required this.telefone});

  static PontoOuColetor fromJson(Map<String, dynamic> json) {
    return PontoOuColetor(
        id: json["id"],
        nome: json["nome"],
        endereco: json["endereco"],
        materiais: json["materiaisRecolhidos"],
        telefone: json["telefone"]);
  }
}
