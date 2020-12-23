import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lista_times/model/time.dart';

class ListaTimes extends StatefulWidget {
  final PageController controller;
  final int page;
  final Equipes equipes;

  const ListaTimes({Key key, this.controller, this.page, this.equipes}) : super(key:key);

  @override
  _ListaTimesState createState() => _ListaTimesState();
}

class _ListaTimesState extends State<ListaTimes> {


  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    final page = widget.page;
    final equipes = widget.equipes;

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
        body: FutureBuilder(
          future: equipes.carregaEquipes(),
          builder:(context, AsyncSnapshot snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());
            if(snapshot.connectionState == ConnectionState.done){
              if (!snapshot.hasData) {
                return Center(child: Text("Não há times cadastrados"));
              }else{
                return Container(
                  child: ListView.builder(                                                  
                  itemCount: equipes.getEquipes.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child:ListTile(
                        leading: Container(
                          margin: const EdgeInsets.only(left:0, right:0),
                          width: 50,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: FileImage(File(equipes.getEquipes[index].icone))
                            ),
                          ),
                        ),
                        title: Text(equipes.getEquipes[index].nome),
                        subtitle: Text(equipes.getEquipes[index].cidade + " - " + equipes.getEquipes[index].estado),
                        trailing: new PopupMenuButton(
                        itemBuilder: (_) => <PopupMenuItem<Map>>[
                              new PopupMenuItem<Map>(
                                  child: const Text('Editar'), value: {'button':'edit','indice':equipes.getEquipes[index].id}),
                              new PopupMenuItem<Map>(
                                  child: const Text('Deletar'), value: {'button':'delete','indice':equipes.getEquipes[index].id}),
                            ],
                        onSelected: (value) => {
                          if(value["button"] == 'edit')
                            print(value["indice"])
                          else
                            setState(() {
                              equipes.deleteOne(value["indice"]);
                            })
                        }),
                      )
                    );
                  })
                );
              }
            }else{
              return Text("Ocorreu um erro inesperado");
            }
          }
        ) 
      );
  }

}