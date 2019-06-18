import 'package:flutter/material.dart';

class Create extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _Create();
  }
}

class _Create extends State<Create>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Crear Producto"),
      ),
    );
  }
}