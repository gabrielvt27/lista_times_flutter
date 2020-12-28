import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lista_times/model/cidades.dart';
import 'package:lista_times/model/estados.dart';
import 'package:lista_times/model/time.dart';

class CriaTime extends StatefulWidget {
  final PageController controller;
  final int page;
  final Equipes equipes;

  const CriaTime({Key key, this.controller, this.page, this.equipes})
      : super(key: key);

  @override
  _CriaTimeState createState() => _CriaTimeState();
}

class _CriaTimeState extends State<CriaTime> {
  String _path;
  String _titulo;
  int _aux;
  int _page;
  Equipes _equipes;
  PageController _controller;
  Time _time;
  bool _flag = false;
  List<Estado> _estados = [];
  List<Cidade> _cidades = [];
  List<Cidade> _originalcidades = [];
  String _selectedEstado = "";
  String _selectedCidade = "";

  final picker = ImagePicker();

  final _nometime = TextEditingController();
  final _fullnametime = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _carregaEstados();
    _carregaCidades();
  }

  @override
  Widget build(BuildContext context) {
    _controller = widget.controller;
    _page = widget.page;
    _equipes = widget.equipes;
    _aux = _equipes.getAlterId;

    if (_aux != 0) {
      _time = _equipes.getTime(_aux);
      _nometime.text = _time.nome;
      _fullnametime.text = _time.fullname;

      if (!_flag) {
        List<Estado> idestado =
          _estados.where((estado) => estado.sigla == _time.estado).toList();
          _cidades = _originalcidades
              .where((cidade) => cidade.estado == idestado[0].id)
              .toList();
        _selectedCidade = _time.cidade;
        _selectedEstado = _time.estado;
        _path = _time.icone;
      }

      _titulo = "Editar Time";
    } else {
      _titulo = "Criar um Time";
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(_titulo),
          backgroundColor: Colors.blue[900],
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                if (_aux != 0) {
                  _controller.animateToPage(_page,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut);
                  _equipes.alterid = 0;
                } else {
                  _controller.animateToPage(_page,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut);
                }
                FocusScope.of(context).unfocus();
              }),
          centerTitle: true,
        ),
        body: Builder(
          builder: (context) => SingleChildScrollView(
              child: Padding(
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
                            onTap: () {
                              _getImage();
                            },
                            child: _path != null
                                ? Container(
                                    width: 150,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: FileImage(File(_path))),
                                    ),
                                  )
                                : Container(
                                    width: 150,
                                    height: 150,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Colors.blue[900], width: 2),
                                        color: Colors.grey[400]),
                                    child: Icon(Icons.camera_alt),
                                  )),
                      ],
                    ),
                  ),
                  _construirInput("Nome do Time", _nometime),
                  Divider(
                    color: Colors.transparent,
                  ),
                  _construirInput("Nome Completo do Time", _fullnametime),
                  Divider(
                    color: Colors.transparent,
                  ),
                  Container(
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 20),
                          child: DropdownButton<String>(
                            value: _selectedEstado,
                            onChanged: (String newValue) {
                              setState(() {
                                _selectedEstado = newValue;
                                List<Estado> idestado = _estados
                                    .where((estado) => estado.sigla == newValue)
                                    .toList();
                                _cidades = _originalcidades
                                    .where((cidade) =>
                                        cidade.estado == idestado[0].id)
                                    .toList();

                                _selectedCidade = _cidades[0].nome;
                                _flag = true;
                              });
                            },
                            underline: Container(
                              height: 1,
                              color: Colors.grey[500],
                            ),
                            items: _estados.map((Estado map) {
                              return new DropdownMenuItem<String>(
                                value: map.sigla,
                                child: new Text(map.sigla,
                                    style: new TextStyle(
                                        color: Colors.black, fontSize: 20)),
                              );
                            }).toList(),
                          ),
                        ),
                        Expanded(
                          child: DropdownButton<String>(
                            value: _selectedCidade,
                            isExpanded: true,
                            onChanged: (String newValue) {
                              setState(() {
                                _selectedCidade = newValue;
                                _flag = true;
                              });
                            },
                            underline: Container(
                              height: 1,
                              color: Colors.grey[500],
                            ),
                            items: _cidades.map((Cidade map) {
                              return new DropdownMenuItem<String>(
                                value: map.nome,
                                child: new Text(map.nome,
                                    style: new TextStyle(
                                        color: Colors.black, fontSize: 20)),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.transparent,
                  ),
                  GestureDetector(
                    child: SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: RaisedButton(
                          color: Colors.blue[900],
                          child: Text(
                            "Salvar",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            _addTime(context);
                          }),
                    ),
                  )
                ],
              ),
            ),
          )),
        ));
  }

  Widget _construirInput(String texto, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      style: TextStyle(fontSize: 20, color: Colors.black),
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue[900], width: 2),
        ),
        labelText: texto,
        labelStyle: TextStyle(color: Colors.grey[600], fontSize: 15),
      ),
      validator: (value) {
        if (value.isEmpty) {
          return "Por favor insira ${texto}";
        }
        return null;
      },
    );
  }

  void _addTime(BuildContext context) {
    if (_formKey.currentState.validate() && _path != null) {
      if (_aux != 0) {
        if (_nometime.text != _time.nome ||
            _fullnametime.text != _time.fullname ||
            _selectedEstado != _time.estado ||
            _selectedCidade != _time.cidade ||
            _path != _time.icone) {
          _showAlertDialog(context);
        }
      } else {
        _criarTime(context);
      }
    } else if (_path == null && _formKey.currentState.validate()) {
      Scaffold.of(context).showSnackBar(SnackBar(
        action: SnackBarAction(label: 'Fechar', onPressed: () {}),
        content: Text("É necessário inserir uma imagem para o Time"),
      ));
    }

    FocusScope.of(context).unfocus();
  }

  void _criarTime(BuildContext context) {
    setState(() {
      Time novoTime = Time(
          id: _equipes.getIterator,
          nome: _nometime.text,
          fullname: _fullnametime.text,
          estado: _selectedEstado,
          cidade: _selectedCidade,
          icone: _path);

      _equipes.addTime(novoTime);
    });

    _nometime.clear();
    _fullnametime.clear();
    _path = null;

    Scaffold.of(context).showSnackBar(SnackBar(
      action: SnackBarAction(label: 'Fechar', onPressed: () {}),
      content: Text("Equipe salva com sucesso!"),
    ));
  }

  void _atualizarTime(BuildContext context) {
    _time.nome = _nometime.text;
    _time.fullname = _fullnametime.text;
    _time.estado = _selectedEstado;
    _time.cidade = _selectedCidade;
    _time.icone = _path;

    _equipes.saveEquipes();
    Scaffold.of(context).showSnackBar(SnackBar(
      action: SnackBarAction(label: 'Fechar', onPressed: () {}),
      content: Text("Equipe salva com sucesso!"),
    ));
  }

  _showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Continue"),
      onPressed: () {
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

  Future _getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File croppedImage = await ImageCropper.cropImage(
          sourcePath: pickedFile.path,
          aspectRatioPresets: Platform.isAndroid
              ? [
                  CropAspectRatioPreset.square,
                  CropAspectRatioPreset.ratio3x2,
                  CropAspectRatioPreset.original,
                  CropAspectRatioPreset.ratio4x3,
                  CropAspectRatioPreset.ratio16x9
                ]
              : [
                  CropAspectRatioPreset.original,
                  CropAspectRatioPreset.square,
                  CropAspectRatioPreset.ratio3x2,
                  CropAspectRatioPreset.ratio4x3,
                  CropAspectRatioPreset.ratio5x3,
                  CropAspectRatioPreset.ratio5x4,
                  CropAspectRatioPreset.ratio7x5,
                  CropAspectRatioPreset.ratio16x9
                ],
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          iosUiSettings: IOSUiSettings(
            title: 'Cropper',
          ));

      if (croppedImage != null) {
        setState(() {
          _path = croppedImage.path;
          _flag = true;
        });
      }
    }
  }

  Future _carregaEstados() async {
    final data = await rootBundle.loadString('assets/data/estados.json');

    final itens = json.decode(data).cast<Map<String, dynamic>>();

    List listaestados =
        itens.map<Estado>((json) => Estado.fromJson(json)).toList();

    setState(() {
      _estados = listaestados;
      _selectedEstado = listaestados[0].sigla;
    });

    return listaestados;
  }

  Future _carregaCidades() async {
    final data = await rootBundle.loadString('assets/data/cidades.json');

    final itens = json.decode(data).cast<Map<String, dynamic>>();

    List<Cidade> listacidades =
        itens.map<Cidade>((json) => Cidade.fromJson(json)).toList();

    setState(() {
      _originalcidades = listacidades;
      _cidades = _originalcidades
          .where((cidade) => cidade.estado == listacidades[0].estado)
          .toList();
      _selectedCidade = listacidades[0].nome;
    });

    return listacidades;
  }
}
