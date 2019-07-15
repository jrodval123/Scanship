import 'package:flutter/material.dart';
import 'package:scanship/scoped-models/product.dart';
import '../models/product.dart';
import 'package:flutter/cupertino.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import '../models/order.dart';

class OrderPage extends StatefulWidget {
  final ProductModel model;

  OrderPage(this.model);
  State<StatefulWidget> createState() {
    return _OrderPageState(model);
  }
}

class _OrderPageState extends State<OrderPage> {
  ProductModel model;
  _OrderPageState(this.model);

  String barcode = "";
  String name = "";
  String id = "";
  String driver = "";
  String truck = "";
  String destination = "";
  List<Product> _products = [];
  Map<String, dynamic> _order = new Map();
  Order order;

  TextEditingController _orderNameController = new TextEditingController();
  TextEditingController _driverController = new TextEditingController();
  TextEditingController _destinationController = new TextEditingController();
  TextEditingController _truckController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      model.fetchProducts();
      _products = model.allProducts;
    });
  }

  void _showDialog(BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Nombre de la orden'),
            content: Column(
              children: <Widget>[
                TextField(
                  controller: _orderNameController,
                  decoration: InputDecoration(hintText: "Orden")
                ),
                TextField(
                  controller: _driverController,
                  decoration: InputDecoration(hintText: "Conductor"),
                ),
                TextField(
                  controller: _destinationController,
                  decoration: InputDecoration(hintText: "Ruta"),
                ),
                TextField(
                  controller: _truckController,
                  decoration: InputDecoration(hintText: "Camion"),
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Guardar'),
                onPressed: () {
                  setState(() {
                    id = _orderNameController.text.toUpperCase();
                    driver = _driverController.text.toUpperCase();
                    destination = _destinationController.text.toUpperCase();
                    truck = _truckController.text.toUpperCase();
                    order = new Order(id, _order, driver, destination, truck);
                    model.pushOrder(order);
                  });
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("OrdenBeta"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              _showDialog(context);
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemBuilder: (BuildContext context, int index) {
                String key = _order.keys.elementAt(index);
                return ListTile(
                  leading: Container(
                    child: Text(_order[key].toString(),
                        style: TextStyle(fontSize: 18)),
                  ),
                  title: Text(
                    '$key',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                );
              },
              itemCount: _order.length,
            ),
          ),
          FlatButton(
            child: Icon(Icons.add, size: 30),
            onPressed: () => barcodeScanning(),
          ),
        ],
      ),
    );
  }

  Future barcodeScanning() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() {
        model.fetchProducts();
        _products = model.allProducts;
        this.barcode = barcode;
        for (var prod in _products) {
          if (prod.barcode == barcode) {
            name = prod.name;
          }
        }
        if (_order.containsKey('$name')) {
          setState(() {
            _order['$name'] += 1;
          });
          return;
        }
        _order['$name'] = 1;
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
