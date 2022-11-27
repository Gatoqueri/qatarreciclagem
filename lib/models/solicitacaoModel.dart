class SolicitacaoModel {
  String docId;
  String userId;
  String nome;
  String data;
  String horas;
  String materiais;
  String endereco;
  String status;
  String? coletorId;

  SolicitacaoModel(
      {required this.userId,
      required this.docId,
      required this.data,
      required this.nome,
      required this.materiais,
      required this.status,
      required this.endereco,
      required this.horas,
      this.coletorId});

  static SolicitacaoModel fromJson(Map<String, dynamic> json) =>
      SolicitacaoModel(
          userId: json["userId"],
          docId: json["docId"],
          data: json["data"],
          horas: json["horas"],
          nome: json["nome"],
          materiais: json["materiais"],
          endereco: json["endereco"],
          status: json["status"],
          coletorId: json["coletorId"]);
}
