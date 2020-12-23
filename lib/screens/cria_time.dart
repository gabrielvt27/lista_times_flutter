import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  String _path;
  String _titulo;
  int _aux = 0;
  int _page;
  Equipes _equipes;
  PageController _controller;
  Time _time;

  final picker = ImagePicker();

  final _nometime    = TextEditingController();
  final _estadotime  = TextEditingController();
  final _cidadetime  = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    _controller = widget.controller;
    _page = widget.page;
    _equipes = widget.equipes;

    _aux = _equipes.getAlterId;

    if(_aux != 0){
      _time = _equipes.getTime(_aux);
      _nometime.text = _time.nome;
      _estadotime.text = _time.estado;
      _cidadetime.text = _time.cidade;
      _path = _time.icone;

      _titulo = "Editar Time";
    }else{
      _titulo = "Criar um Time";
    }

    
    return Scaffold(
      appBar: AppBar(
        title: Text(_titulo),
        backgroundColor: Colors.blue[900],
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: (){
          setState(() {
            _aux = 0;
            _controller.animateToPage(_page, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
          });
        }),
        centerTitle: true,
      ),
      body: Builder(
        builder: (context) => 
          SingleChildScrollView(
          child:Padding(
            padding: const EdgeInsets.all(30.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: (){
                            getImage();
                          },
                          child: _path != null
                          ? Container(
                            width: 180,
                            height: 180,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: FileImage(File(_path))
                              ),
                              border: Border.all(
                                color:Colors.blue[900],
                                width: 2
                              )
                            ),
                          )
                          : Container(
                            width: 180,
                            height: 180,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color:Colors.blue[900],
                                width: 2
                              ),
                              color: Colors.grey[400]
                            ),
                            child: Icon(
                              Icons.camera_alt
                            ),
                          )
                        ),
                      ],
                    ),
                  ),
                  construirInput("Nome do Time", _nometime),
                  Divider(),
                  construirInput("Estado", _estadotime),
                  Divider(),
                  construirInput("Cidade", _cidadetime),
                  Divider(),
                  GestureDetector(
                    child: SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: RaisedButton(
                        color: Colors.blue[900],
                        child: Text("Salvar",style: TextStyle(color: Colors.white),),
                        onPressed: () => {
                          _addTime(context)
                        }
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ),
      )
    );
  }

  Widget construirInput(String texto, TextEditingController controller){
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey, width: 1.0),
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


  void _addTime(BuildContext context){
    FocusScope.of(context).unfocus();
    if (_formKey.currentState.validate() && _path != null) {

      if(_aux != 0){
        if(_nometime.text != _time.nome || _estadotime.text != _time.estado || _cidadetime.text != _time.cidade || _path != _time.icone){
          showAlertDialog(context);
        }
      }else{
        _criarTime(context);
      }

    }else if(_path == null && _formKey.currentState.validate()){
      Scaffold.of(context).showSnackBar(
        SnackBar(
          action: SnackBarAction(
              label: 'Fechar',
              onPressed: (){}
          ),
          content: Text("É necessário inserir uma imagem para o Time"),
        )
      );
    }
  }

  void _criarTime(BuildContext context){
    setState(() {
      Time novoTime = Time(
        id    : _equipes.getIterator,
        nome  : _nometime.text,
        estado: _estadotime.text,
        cidade: _cidadetime.text,
        icone : _path
      );

      _equipes.addTime(novoTime);

      _nometime.text = "";
      _estadotime.text = "";
      _cidadetime.text = "";
      _path = null;
      
    });

    Scaffold.of(context).showSnackBar(
      SnackBar(
        action: SnackBarAction(
            label: 'Fechar',
            onPressed: (){}
        ),
        content: Text("Equipe salva com sucesso!"),
      )
    );
  }

  void _atualizarTime(BuildContext context){
    _time.nome = _nometime.text;
    _time.estado = _estadotime.text;
    _time.cidade = _cidadetime.text;
    _time.icone = _path;

    Scaffold.of(context).showSnackBar(
      SnackBar(
        action: SnackBarAction(
            label: 'Fechar',
            onPressed: (){}
        ),
        content: Text("Equipe salva com sucesso!"),
      )
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Continue"),
      onPressed:  () {
        Navigator.of(context).pop();
        _atualizarTime(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Deseja alterar esse cadastro?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _path = pickedFile.path;
      } else {
        print('No image selected.');
      }
    });
  }
}