import 'package:flutter/material.dart';

class CriaTime extends StatefulWidget {
  final PageController controller;
  final int page;

  const CriaTime({Key key, this.controller, this.page}) : super(key:key);

  @override
  _CriaTimeState createState() => _CriaTimeState();
}

class _CriaTimeState extends State<CriaTime> {

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    final page = widget.page;
    return Scaffold(
        appBar: AppBar(
          title: Text("Criar um Time"),
          backgroundColor: Colors.blue[900],
          actions: [
            IconButton(icon: Icon(Icons.add), onPressed: (){
              controller.animateToPage(page, duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
            })
          ],
          centerTitle: true,
        ),
        body: Container(
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
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.grey[100],borderRadius: BorderRadius.circular(15),border: Border.all(width: 1,color: Colors.black)),
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black, width: 1.0),
                          ),
                          border: OutlineInputBorder(),
                          focusedBorder:OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue[900], width: 2.0),
                          ),
                          labelText: "Nome do Time",
                          labelStyle: TextStyle(color: Colors.black,fontSize: 17)
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                      Divider(),
                      TextFormField(
                        decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black, width: 1.0),
                          ),
                          border: OutlineInputBorder(),
                          focusedBorder:OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue[900], width: 2.0),
                          ),
                          labelText: "Estado",
                          labelStyle: TextStyle(color: Colors.black,fontSize: 17)
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                      Divider(),
                      TextFormField(
                        decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black, width: 1.0),
                          ),
                          border: OutlineInputBorder(),
                          focusedBorder:OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue[900], width: 2.0),
                          ),
                          labelText: "Cidade",
                          labelStyle: TextStyle(color: Colors.black,fontSize: 17)
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        )
      );
  }
}