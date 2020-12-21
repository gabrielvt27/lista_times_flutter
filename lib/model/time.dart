import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class Equipes{
  List<Time> _equipes = [];

  Future carregaEquipes() async{
    print("######################################################\n");
    print("  + Carregando Equipes...");

    try{
      final directory = await getApplicationDocumentsDirectory();
      final file = File("${directory.path}/equipes.json");
      final aux = await file.readAsString();
      final parsed = json.decode(aux).cast<Map<String,dynamic>>();
      print("  + Equipes Carregadas!!!");
      print("  ${parsed}");
      return this._equipes = parsed.map<Time>((json)=>Time.fromJson(json)).toList();

    }catch(e){
      return null;
    }
  }

  void addTime(Time time) async{
    this._equipes.add(time);

    String data = json.encode(this._equipes);

    final directory = await getApplicationDocumentsDirectory();
    final file = File("${directory.path}/equipes.json");

    file.writeAsString(data);

    print("  + Time: ${time.nome} adicionado!!!");
  }

  void deleteOne(int indice) async{
    List<Time> novaLista = _equipes.where((element) => element.id != indice).toList();

    this._equipes = novaLista;
    
    String data = json.encode(this._equipes);

    final directory = await getApplicationDocumentsDirectory();
    final file = File("${directory.path}/equipes.json");

    file.writeAsString(data);
    print("  - Time deletado!!!");
  }

  List<Time> get getEquipes{
    return this._equipes;
  }
}

class Time{
  final int id;
  final String nome;
  final String cidade;
  final String estado;

  Time({this.id, this.nome, this.cidade, this.estado});

  factory Time.fromJson(Map<String, dynamic> json){
    return Time(
      id: json["id"],
      nome: json["nome"],
      cidade: json["cidade"],
      estado: json["estado"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "nome": nome,
    "cidade": cidade,
    "estado": estado,
  };
}