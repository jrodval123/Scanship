import 'package:flutter/material.dart';
import './product_edit.dart';
import './product_list.dart';

class Products extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _ProductsState();
  }


}

class _ProductsState extends State<Products>{
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(255, 222, 3, 1.0),
          title: Text('Administrador de Productos'),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.create),
                text: 'Crear Producto',
              ),
              Tab(
                icon: Icon(Icons.list),
                text: 'My Products',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[ProductEdit(), ProductListPage()],
        ),
      ),
    );
  }
}