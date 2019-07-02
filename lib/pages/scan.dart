import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:scanship/pages/create_order.dart';
import 'package:scanship/pages/products.dart';
import 'package:scanship/scoped-models/product.dart';

class Scan extends StatefulWidget {
  final ProductModel model;
  Scan(this.model);

  @override
  State<StatefulWidget> createState() {
    return _ScanState(model);
  }
}

class _ScanState extends State<Scan> {
  String barcode = "";
  String name = "";
  final ProductModel model;
  _ScanState(this.model);
  @override
  void initState() {
    model.fetchProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Escanear Codigo de Barras"),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: GridView.count(
                crossAxisCount: 2,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                  GestureDetector(
                    child: Card(
                      child: Column(
                        children: <Widget>[
                          Container(
                              child: Image.network(
                            'https://images.vexels.com/media/users/3/157862/isolated/preview/5fc76d9e8d748db3089a489cdd492d4b-barcode-scanning-icon-by-vexels.png',
                            height: 100.0,
                            width: 400.0,
                            fit: BoxFit.contain,
                          )),
                          SizedBox(
                            height: 30.0,
                          ),
                          Text(
                            'Revisar Codigo',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                      barcodeScanning();
                    },
                  ),
                  GestureDetector(
                    child: Card(
                      child: Column(
                        children: <Widget>[
                          Container(
                              child: Image.network(
                            'https://cdn4.iconfinder.com/data/icons/eldorado-transport/40/truck_1-512.png',
                            height: 100.0,
                            width: 400.0,
                            fit: BoxFit.contain,
                          )),
                          SizedBox(
                            height: 30.0,
                          ),
                          Text(
                            'Empezar Orden',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          )
                          // Text('Productos')
                        ],
                      ),
                    ),
                    onTap: ()=>Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateOrder(ProductModel()))),
                  ),
                ],
              ),
            ),
            Expanded(
                child: Text(
              "Producto : " + barcode,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ))
          ],
        ));
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Producto no encontrado"),
            content: Text(
                "El producto no se encuentra en la base de datos, ¿Desea agregarlo?"),
            actions: <Widget>[
              FlatButton(
                child: Text('No'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              FlatButton(
                  child: Container(
                    child: Text('Si'),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Products(ProductModel())));
                  }),
            ],
          );
        });
  }

  Future barcodeScanning() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() {
        model.fetchProducts();
        this.barcode = model.check(barcode);
        if (this.barcode == "N?A") {
          _showDialog();
        }
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
