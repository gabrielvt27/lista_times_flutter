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
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }else{
              return Container(
                child: ListView.builder(                                                  
                itemCount: equipes.getEquipes.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child:ListTile(
                      title: Text(equipes.getEquipes[index].nome),
                      subtitle: Text(equipes.getEquipes[index].cidade + " - " + equipes.getEquipes[index].estado),
                      trailing: IconButton(icon: Icon(Icons.more_vert), onPressed: (){}),
                      onLongPress: () =>{
                        setState(() {
                          equipes.deleteOne(index);
                        })
                      },
                    )
                  );
                })
              );
            }
          }
        ) 
      );
  }
}