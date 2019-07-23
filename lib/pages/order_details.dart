import 'package:flutter/material.dart';
import '../models/order.dart';

class OrderDetails extends StatelessWidget{
  final Order order;
  OrderDetails(this.order);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          elevation: 0.0,
          title: Text(
            order.id,
            style: TextStyle(fontSize: 20, letterSpacing: 2.0),
          ),
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(5.0),
        itemCount:order.map.length,
        itemBuilder: (BuildContext context, int index){
          String key = order.map.keys.elementAt(index);
          return Column(
            children: <Widget>[
              ListTile(
                  leading: Container(
                    child: Text(order.map[order.map.keys.elementAt(index)].toString(),
                        style: TextStyle(fontSize: 18)),
                  ),
                  title: Text(
                    order.map.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                 Divider(),
            ],
          );
        },
      ),
    );
  }
}