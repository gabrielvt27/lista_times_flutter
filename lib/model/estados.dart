class Estado {
  int id;
  String sigla;
  String nome;

  Estado({this.id, this.sigla, this.nome});

  factory Estado.fromJson(Map<String, dynamic> json) {
    return Estado(
        id: int.parse(json['ID']), sigla: json['Sigla'], nome: json['Nome']);
  }

  Map<String, dynamic> toJson() => {"id": id, "nome": nome, "sigla": sigla};
}
