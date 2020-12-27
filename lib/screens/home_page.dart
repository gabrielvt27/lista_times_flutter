import 'package:flutter/material.dart';
import 'package:lista_times/model/time.dart';
import 'package:lista_times/screens/cria_time.dart';
import 'package:lista_times/screens/lista_times.dart';

class HomePage extends StatelessWidget {
  final _pagecontroller = PageController();
  final _equipes = Equipes();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pagecontroller,
      physics: NeverScrollableScrollPhysics(),
      children: [
        ListaTimes(controller: _pagecontroller, page: 1, equipes: _equipes),
        CriaTime(controller: _pagecontroller, page: 0, equipes: _equipes)
      ],
    );
  }
}
