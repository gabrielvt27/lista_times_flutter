class Cidade {
  int id;
  String nome;
  int estado;

  Cidade({this.id, this.nome, this.estado});

  factory Cidade.fromJson(Map<String, dynamic> json) {
    return Cidade(
        id: int.parse(json['ID']),
        estado: int.parse(json['Estado']),
        nome: json['Nome']);
  }

  Map<String, dynamic> toJson() => {"id": id, "nome": nome, "estado": estado};
}
