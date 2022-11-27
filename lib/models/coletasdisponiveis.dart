class ColetasDisponiveisModel {
  String docId;
  String userId;
  String nome;
  String endereco;
  String materiais;
  String telefone;
  String data;
  String status;
  String horas;
  String? coletorId;

  ColetasDisponiveisModel(
      {required this.docId,
      required this.userId,
      required this.nome,
      required this.endereco,
      required this.status,
      required this.materiais,
      required this.telefone,
      required this.data,
      this.coletorId,
      required this.horas});

  static ColetasDisponiveisModel fromJson(Map<String, dynamic> json) =>
      ColetasDisponiveisModel(
          docId: json["docId"],
          userId: json["userId"],
          nome: json["nome"],
          endereco: json["endereco"],
          materiais: json["materiais"],
          telefone: json["telefone"],
          data: json["data"],
          status: json["status"],
          horas: json["horas"],
          coletorId: json["coletorId"]);
}
