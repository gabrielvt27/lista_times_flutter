class Time{
  final int id;
  final String nome;
  final String cidade;
  final String estado;
  final String icone;

  Time({this.id, this.nome, this.cidade, this.estado, this.icone});

  factory Time.fromJson(Map<String, dynamic> json){
    return Time(
      id: json["id"],
      nome: json["nome"],
      cidade: json["cidade"],
      estado: json["estado"],
      icone: json["icone"]
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "nome": nome,
    "cidade": cidade,
    "estado": estado,
    "icone": icone
  };
}