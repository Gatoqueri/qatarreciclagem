class NotificacaoModel {
  String? coletor;
  String coletorId;
  String mensagem;
  String notificacaoId;

  NotificacaoModel(
      {required this.coletorId,
      required this.mensagem,
      required this.notificacaoId,
      this.coletor});

  static NotificacaoModel fromJson(Map<String, dynamic> json) {
    return NotificacaoModel(
        coletorId: json["coletorId"],
        mensagem: json["mensagem"],
        notificacaoId: json["notificacaoId"],
        coletor: json["coletor"]);
  }
}
