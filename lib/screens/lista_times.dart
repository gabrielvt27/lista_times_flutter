import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ListaTimes extends StatefulWidget {
  @override
  _ListaTimesState createState() => _ListaTimesState();
}

class _ListaTimesState extends State<ListaTimes> {

  List _listaTimes = ["São Caetano", "Mauá"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Lista de Times"),
          backgroundColor: Colors.purple,
          actions: [
            IconButton(icon: Icon(Icons.add), onPressed: (){})
          ],
          centerTitle: true,
        ),
        body: 
        Container(
          padding: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.purple[100],
                Colors.purple[800],
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter
            )
          ),
          child: new ListView.builder(
            itemCount: _listaTimes.length,
            itemBuilder: (_, index){
              return Card(
                child:ListTile(
                  title: Text(_listaTimes[index])
                )
              );
            }
          ),
        )
      );
  }

  // Função para buscar o arquivo json com a lista de times
  Future<File> _getFile() async{
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/assets/lista_times.json");
  }

  // Função para salvar os dados dos times no arquivo json
  Future<File> _saveFile() async{
    String data = json.encode(_listaTimes);

    final file = await _getFile();

    return file.writeAsString(data);
  }

  Future<String> _readData() async{
    try{
      final file = await _getFile();

      return file.readAsString();
    }catch(e){
      // TODO: melhorar tratamento de erros ao ler os dados
      return null;
    }
  }
}