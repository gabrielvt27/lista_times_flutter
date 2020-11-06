import 'package:flutter/material.dart';
import 'package:lista_times/screens/cria_time.dart';
import 'package:lista_times/screens/lista_times.dart';

class HomePage extends StatelessWidget {

  final _pagecontroller = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pagecontroller,
      scrollDirection: Axis.vertical,
      physics: NeverScrollableScrollPhysics(),
      children: [
        ListaTimes(controller: _pagecontroller, page: 1),
        CriaTime(controller: _pagecontroller, page: 0)
      ],
    );
  }
}