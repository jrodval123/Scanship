import 'package:flutter/material.dart';

import '../models/product.dart';
import '../helpers/ensure_visible.dart';

class ProductEdit extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _ProductEdit();
  }
}

class _ProductEdit extends State<ProductEdit>{

  
  final Map<String, dynamic> _formData = {
    'name':null,
    'code':null,
    'barcode':null,
  };

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _nameFocusNode = FocusNode();
  //final _barcodeFocusNode = FocusNode();
  final _codeFocusNode = FocusNode();

  Widget _buildNameField(Product product){
    return EnsureVisibleWhenFocused(
      focusNode: _nameFocusNode,
      child: TextFormField(
        focusNode: _nameFocusNode,
        decoration: InputDecoration(labelText: "Nombre del Producto",),
        initialValue: product == null ? '' : product.name,
        validator: (String value) {
          if (value.isEmpty || value.length <= 0) {
            return 'Nombre es obligatorio';
          }
        },
        onSaved: (String value) {
          _formData['name'] = value;
        },
      ),
    );
  }
  Widget _buildCodeField(Product product){
    return EnsureVisibleWhenFocused(
      focusNode: _codeFocusNode,
      child: TextFormField(
        focusNode: _codeFocusNode,
        decoration: InputDecoration(labelText: "Codigo Sistema"),
        initialValue: product == null ? '' : product.code,
        validator: (String value) {
          if (value.isEmpty || value.length <= 0) {
            return 'Codigo es obligatorio';
          }
        },
        onSaved: (String value) {
          _formData['code'] = value;
        },
      ),
    );
  }
  Widget _buildPageContent(BuildContext context, Product product){
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        margin: EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: targetPadding / 2),
            children: <Widget>[
              _buildNameField(product),
              _buildCodeField(product)
            ],
          ),
        )
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Administrador de Productos"),
      ),
      body: _buildPageContent(context, Product('test Product', '099091203', '0090')),
    );
  }
}