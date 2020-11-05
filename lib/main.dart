import 'package:flutter/material.dart';
import 'package:lista_times/screens/home_page.dart';

void main() {
  runApp(Home());
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Lista de Times",
      debugShowCheckedModeBanner: false,
      home: HomePage()
    );
  }
}
