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
  final picker = ImagePicker();

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
                          _addTime(equipes, context)
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


  void _addTime(Equipes equipes, BuildContext context){
    if (_formKey.currentState.validate() && _path != null) {
      setState(() {
        
        Time novoTime = Time(
          id    : equipes.getIterator,
          nome  : _nometime.text,
          estado: _estadotime.text,
          cidade: _cidadetime.text,
          icone : _path
        );

        equipes.addTime(novoTime);

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