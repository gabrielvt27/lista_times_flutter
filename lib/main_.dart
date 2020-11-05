import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lista_times/time.dart';

void main() {
  runApp(ListaTimes());
}

class ListaTimes extends StatefulWidget {
  @override
  _ListaTimesState createState() => _ListaTimesState();
}

class _ListaTimesState extends State<ListaTimes> {
  
  Future<List<Time>> _listatimes;
  
  @override
  void initState() {
    _listatimes = _loadFromAsset();
    super.initState();
  }
  //final List<String> _listatimes = ["São Caetano", "São Bernardo"];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Lista de Times"),
          backgroundColor: Colors.deepPurple,
          actions: [
            IconButton(icon: Icon(Icons.add), onPressed: (){})
          ],
        ),
        body: new FutureBuilder(
          future: _listatimes,
          builder: (context, snapshot){
            return snapshot.hasData
              ? ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index){
                  return Card(
                    child: ListTile(
                      leading: Image.asset(snapshot.data[index].icone,width: 50.00,height: 50.00), // no matter how big it is, it won't overflow,
                      title: Text(snapshot.data[index].nome),
                      subtitle: Text(snapshot.data[index].cidade+" - "+snapshot.data[index].estado),
                      trailing: Icon(Icons.more_vert),
                    ),
                  );
                }
              )
              : Center(child: CircularProgressIndicator());
          },
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

Future<List<Time>> _loadFromAsset() async {
  final resposta = await rootBundle.loadString("assets/lista_times.json");
  final parsed = jsonDecode(resposta).cast<Map<String,dynamic>>();
  final lista = parsed.map<Time>((json)=>Time.fromJson(json)).toList();
  return lista;
}