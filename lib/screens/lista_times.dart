import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';

class ListaTimes extends StatefulWidget {
  final PageController controller;
  final int page;

  const ListaTimes({Key key, this.controller, this.page}) : super(key:key);

  @override
  _ListaTimesState createState() => _ListaTimesState();
}

class _ListaTimesState extends State<ListaTimes> {

  List _listaTimes = [];

  @override
  void initState() {
    super.initState();

    _readData().then((data) {
      setState(() {
        _listaTimes = json.decode(data);
      });
    });
  }

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
              controller.animateToPage(page, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
            })
          ],
          centerTitle: true,
        ),
        body: Stack(
          children: [ 
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
                      title: Text(_listaTimes[index]["nome"]),
                      subtitle: Text(_listaTimes[index]["cidade"] + " - " + _listaTimes[index]["estado"]),
                      trailing: IconButton(icon: Icon(Icons.more_vert), onPressed: (){}),
                    )
                  );
                }
              ),
            ),
          ]
        )
      );
  }

  // Função para buscar o arquivo json com a lista de times
  Future<File> _getFile() async{
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/lista_times.json");
  }

  Future<String> _readData() async{
    try{
      final directory = await getApplicationDocumentsDirectory();
      final file = File("${directory.path}/lista_times.json");
      return file.readAsString();
    }catch(e){
      return null;
    }
  }
}