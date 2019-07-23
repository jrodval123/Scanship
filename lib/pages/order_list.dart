import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scanship/models/order.dart';
import 'package:scanship/pages/order_details.dart';
import 'package:scanship/scoped-models/product.dart';
import 'package:scoped_model/scoped_model.dart';

class OrderListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          elevation: 0.0,
          title: Text(
            'Historial de Ordenes',
            style: TextStyle(fontSize: 28, letterSpacing: 2.0),
          ),
        ),
      ),
      body: ScopedModelDescendant<ProductModel>(
        builder: (BuildContext context, Widget child, ProductModel model) {
          model.fetchOrders();
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return makeCard(model.allOrders[index], context);
            },
            itemCount: model.allOrders.length,
          );
        },
      ),
    );
  }
}

Card makeCard(Order order, BuildContext context) => Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(64, 75, 96, .9),
        ),
        child: makeTile(order, context),
      ),
    );

ListTile makeTile(Order order, BuildContext context) => ListTile(
    contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
    leading: Container(
      padding: EdgeInsets.only(right: 12.0),
      decoration: new BoxDecoration(
          border: new Border(
              right: new BorderSide(width: 1.0, color: Colors.white24))),
      child: Icon(Icons.check_circle_outline, color: Colors.white),
    ),
    title: Text(
      order.id.toString(),
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    subtitle: Row(
      children: <Widget>[
        Icon(Icons.local_shipping, color: Colors.yellowAccent),
        Text(order.truck.toString(), style: TextStyle(color: Colors.white)),
        Icon(
          Icons.person,
          color: Colors.yellowAccent,
        ),
        Text(
          order.driver.toString(),
          style: TextStyle(color: Colors.white),
        )
      ],
    ),
    trailing: IconButton(
      icon: Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
      onPressed: () => Navigator.push(context,
          MaterialPageRoute(builder: (context) => OrderDetails(order))),
    ));
