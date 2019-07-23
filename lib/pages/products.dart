import 'package:flutter/material.dart';
import 'package:scanship/scoped-models/product.dart';
import './product_edit.dart';
import './product_list.dart';

class Products extends StatefulWidget{
  final ProductModel model;
  Products(this.model);

  @override
  State<StatefulWidget> createState() {
    return _ProductsState();
  }
}

class _ProductsState extends State<Products>{
  @override
  void initState() {
    widget.model.fetchProducts();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Color.fromRGBO(255, 222, 3, 1.0),
          title: Text('Administrador de Productos'),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.list),
                text: 'Productos',
              ),
              Tab(
                icon: Icon(Icons.create),
                text: 'Crear Producto',
              ),
              
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[ProductListPage(),ProductEdit()],
        ),
      ),
    );
  }
}