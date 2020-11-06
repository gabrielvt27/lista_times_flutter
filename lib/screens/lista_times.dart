import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ListaTimes extends StatefulWidget {
  final PageController controller;
  final int page;

  const ListaTimes({Key key, this.controller, this.page}) : super(key:key);

  @override
  _ListaTimesState createState() => _ListaTimesState();
}

class _ListaTimesState extends State<ListaTimes> {

  List _listaTimes = ["São Caetano"];
/*
  @override
  void initState() {
    super.initState();

    _readData().then((data) {
      setState(() {
        _listaTimes = json.decode(data);
      });
    });
  }*/

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    final page = widget.page;
    return Scaffold(
        appBar: AppBar(
          title: Text("Lista de Times"),
          backgroundColor: Colors.blue[900],
          actions: [
            IconButton(icon: Icon(Icons.add), onPressed: (){
              controller.animateToPage(page, duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
            })
          ],
          centerTitle: true,
        ),
        body: 
        Container(
          padding: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue[300],
                Colors.blue[900],
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft
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
    return File("${directory.path}/lista_times.json");
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
      return null;
    }
  }
}