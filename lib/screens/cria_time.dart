import 'package:flutter/material.dart';
import 'package:lista_times/model/time.dart';
class CriaTime extends StatefulWidget {
  final PageController controller;
  final int page;
  final Equipes equipes;

  const CriaTime({Key key, this.controller, this.page, this.equipes}) : super(key:key);

  @override
  _CriaTimeState createState() => _CriaTimeState();
}

class _CriaTimeState extends State<CriaTime> {

  final _nometime    = TextEditingController();
  final _estadotime  = TextEditingController();
  final _cidadetime  = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    final controller = widget.controller;
    final page = widget.page;
    final equipes = widget.equipes;

    return Scaffold(
        appBar: AppBar(
          title: Text("Criar um Time"),
          backgroundColor: Colors.blue[900],
          leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: (){
            controller.animateToPage(page, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
          }),
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
              )
            ),
            GestureDetector(
              onTap: (){
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              child: Center(
                child: SingleChildScrollView(
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
                              construirInput("Nome do Time", _nometime),
                              Divider(),
                              construirInput("Estado", _estadotime),
                              Divider(),
                              construirInput("Cidade", _cidadetime),
                              Divider(),
                              SizedBox(
                                width: double.infinity,
                                height: 40,
                                child: RaisedButton(
                                  color: Colors.blue[900],
                                  child: Text("Salvar",style: TextStyle(color: Colors.white),),
                                  onPressed: () => _addTime(equipes),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        )
      );
  }

  Widget construirInput(String texto, TextEditingController controller){
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black, width: 1.0),
        ),
        border: OutlineInputBorder(),
        focusedBorder:OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue[900], width: 2.0),
        ),
        labelText: texto,
        labelStyle: TextStyle(color: Colors.black,fontSize: 17)
      ),
      validator: (value) {
        if (value.isEmpty) {
          return "Por favor insira ${texto}";
        }
        return null;
      },
    );
  }


  void _addTime(Equipes equipes){
    if (_formKey.currentState.validate()) {
      setState(() {
        
        Time novoTime = Time(
          id: equipes.getEquipes.length + 1,
          nome:_nometime.text,
          estado:_estadotime.text,
          cidade:_cidadetime.text
        );

        equipes.addTime(novoTime);

        _nometime.text = "";
        _estadotime.text = "";
        _cidadetime.text = "";
        
      });
    }
  }

}