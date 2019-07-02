import 'package:flutter/material.dart';
import 'package:scanship/scoped-models/product.dart';
import 'package:scoped_model/scoped_model.dart';

class CreateOrder extends StatefulWidget{
  final ProductModel model;

  CreateOrder(this.model);

  @override
  State<StatefulWidget> createState() {
    return _CreateOrderState(model);
  }
}

class _CreateOrderState extends State<CreateOrder>{
  
  final ProductModel model;
  String barcode="";
  String name="";

  _CreateOrderState(this.model);

  @override
  void initState() {
    model.fetchProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
   return ScopedModelDescendant<ProductModel>(
     builder: (BuildContext context, Widget child, ProductModel model){
       model.fetchProducts();
       return ListView.builder(
         itemBuilder: (BuildContext context, int index){
           return Dismissible(
              key: Key(model.allProducts[index].name),
              onDismissed: (DismissDirection direction) {
                model.selectProduct(index);
                if (direction == DismissDirection.endToStart) {
                  model.deleteProduct();
                } else if (direction == DismissDirection.startToEnd) {
                  print('Swiped start to end');
                } else {
                  print('Other swiping');
                }
              },
              background: Container(color: Colors.red),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          NetworkImage('https://cdn1.iconfinder.com/data/icons/storage-2/24/537-512.png'),
                    ),
                    title: Text(model.allProducts[index].name),
                    // subtitle:
                    //     Text('\$${model.allProducts[index].price.toString()}'),
                    trailing: _buildEditButton(context, index, model),
                  ),
                  Divider(),
                ],
              ),
            );
         },
         itemCount: model.allProducts.length,
       );
     },
   );
  }
  Widget _buildEditButton(
      BuildContext context, int index, ProductModel model) {
    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {
        model.selectProduct(index);
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (BuildContext context) {
          return null;
        }));
      },
    );
  }
}