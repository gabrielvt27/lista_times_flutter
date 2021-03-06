import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class Equipes {
  List<Time> _equipes = [];
  int _iterator = 1;
  int _alterid = 0;

  Equipes() {
    carregaEquipes();

    //_reset();
  }

  Future carregaEquipes() async {
    if (this._equipes.length == 0) {
      try {
        //print("######################################################\n");
        //print("  + Carregando Equipes...");
        final directory = await getApplicationDocumentsDirectory();
        final file = File("${directory.path}/equipes.json");
        final aux = await file.readAsString();
        final parsed = json.decode(aux).cast<Map<String, dynamic>>();
        this._equipes =
            parsed.map<Time>((json) => Time.fromJson(json)).toList();
        //print("  + ${this._equipes.length} Equipes Carregadas!!!");
        //print("  ${parsed}");
        this._iterator = this._equipes[this._equipes.length - 1].id + 1;
        return this._equipes;
      } catch (e) {
        return null;
      }
    } else {
      return this._equipes;
    }
  }

  void _reset() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File("${directory.path}/equipes.json");

    file.writeAsString("[]");
  }

  void saveEquipes() async {
    String data = json.encode(this._equipes);

    final directory = await getApplicationDocumentsDirectory();
    final file = File("${directory.path}/equipes.json");

    file.writeAsString(data);
  }

  void addTime(Time time) async {
    this._equipes.add(time);
    this._iterator++;
    saveEquipes();

    print("  + Time: ${time.nome} adicionado!!!");
  }

  Time getTime(int indice) {
    List<Time> aux = _equipes.where((element) => element.id == indice).toList();
    return aux[0];
  }

  void deleteOne(int indice) async {
    List<Time> novaLista =
        _equipes.where((element) => element.id != indice).toList();

    this._equipes = novaLista;

    String data = json.encode(this._equipes);

    final directory = await getApplicationDocumentsDirectory();
    final file = File("${directory.path}/equipes.json");

    file.writeAsString(data);
    print("  - Time deletado!!!");
  }

  List<Time> get getEquipes {
    return this._equipes;
  }

  int get getIterator {
    return this._iterator;
  }

  set alterid(int id) {
    this._alterid = id;
  }

  int get getAlterId {
    return this._alterid;
  }
}

class Time {
  int id;
  String nome;
  String fullname;
  String cidade;
  String estado;
  String icone;

  Time({this.id, this.nome, this.fullname, this.cidade, this.estado, this.icone});

  factory Time.fromJson(Map<String, dynamic> json) {
    return Time(
      id: json["id"],
      nome: json["nome"],
      fullname: json["fullname"],
      cidade: json["cidade"],
      estado: json["estado"],
      icone: json["icone"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "nome": nome,
        "fullname": fullname,
        "cidade": cidade,
        "estado": estado,
        "icone": icone,
      };
}
