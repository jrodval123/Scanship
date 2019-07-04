import 'package:flutter/material.dart';
import 'package:scanship/scoped-models/product.dart';
import '../models/product.dart';
import 'package:flutter/cupertino.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';

class CreateOrder extends StatefulWidget {
  final ProductModel model;

  CreateOrder(this.model);

  @override
  State<StatefulWidget> createState() {
    return _CreateOrderState(model);
  }
}

class _CreateOrderState extends State<CreateOrder> {
  final ProductModel model;
  String barcode = "";
  String name = "";

  List<Product> order = [];

  _CreateOrderState(this.model);

  @override
  void initState() {
    model.fetchProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Orden "),
          actions: <Widget>[
            // IconButton(
            //   icon: Icon(Icons.add),
            //   onPressed: ()=>barcodeScanning(),
            // ),
            IconButton(
              icon: Icon(Icons.save),
              onPressed: () {},
            )
          ],
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(10),
                itemBuilder: (BuildContext context, int index) {
                  return Dismissible(
                    key: Key(order[index].name),
                    onDismissed: (DismissDirection direction) {
                      if (direction == DismissDirection.endToStart) {}
                    },
                    background: Container(
                      color: Colors.red,
                    ),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          leading: Container(
                            child: Text(
                              "1",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                          title: Text(order[index].name,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18)),
                        ),
                        Divider(),
                      ],
                    ),
                  );
                },
                itemCount: order.length,
              ),
            ),
            FlatButton(
              onPressed: () => barcodeScanning(),
              child: Icon(
                Icons.add,
                size: 30,
              ),
            ),
          ],
        ));
  }

  Future barcodeScanning() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() {
        model.fetchProducts();
        this.barcode = model.check(barcode);
        order.add(model.checkInList(barcode));
        if (this.barcode == "N?A") {}
        // name = model.check(barcode);
      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'No camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => this.barcode = 'Nothing captured.');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }
}
