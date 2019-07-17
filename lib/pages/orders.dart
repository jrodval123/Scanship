import 'package:flutter/material.dart';
import 'package:scanship/models/order.dart';
import 'package:scanship/scoped-models/product.dart';

class OrdersPage extends StatefulWidget {
  final ProductModel model;
  OrdersPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _OrdersPageState(model);
  }
}

class _OrdersPageState extends State<OrdersPage> {
  ProductModel model;
  _OrdersPageState(this.model);

  List<Order> _orders = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      _orders = this.model.allOrders;
    });
  }

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
      body: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: _orders.length,
        itemBuilder: (BuildContext context, int index) {
          return makeCard(_orders[index]);
        },
      ),
    );
  }
}

Card makeCard(Order order) => Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(64, 75, 96, .9),
        ),
        child: makeTile(order),
      ),
    );

ListTile makeTile(Order order) => ListTile(
    contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
    leading: Container(
      padding: EdgeInsets.only(right: 12.0),
      decoration: new BoxDecoration(
          border: new Border(
              right: new BorderSide(width: 1.0, color: Colors.white24))),
      child: Icon(Icons.autorenew, color: Colors.white),
    ),
    title: Text(
      order.id,
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

    subtitle: Row(
      children: <Widget>[
        Icon(Icons.linear_scale, color: Colors.yellowAccent),
        Text(order.driver, style: TextStyle(color: Colors.white))
      ],
    ),
    trailing:
        Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0));
