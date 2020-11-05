import 'package:flutter/material.dart';
import 'package:lista_times/screens/lista_times.dart';

class HomePage extends StatelessWidget {

  final pagecontroller = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      physics: NeverScrollableScrollPhysics(),
      children: [
        ListaTimes(),
      ],
    );
  }
}