import 'package:flutter/material.dart';
import './product-edit.dart';

class Products extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _ProductsState();
  }


}

class _ProductsState extends State<Products>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Productos"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductEdit()));
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          ListTile(
            title: Text("Escanear"),
            onTap: (){
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text("Escanear"),
            onTap: (){
            },
          ),ListTile(
            title: Text("Escanear"),
            onTap: (){
            },
          )
        ],
      ),
    );
  }
}