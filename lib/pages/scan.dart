import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
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
      body: Center(
        child: Column(
          children: <Widget>[
            new Container(
              child: new RaisedButton(
                  onPressed: barcodeScanning, child: new Text("Escanear")),
              padding: const EdgeInsets.all(8.0),
            ),
            new Padding(
              padding: const EdgeInsets.all(8.0),
            ),
            new Container(
              child: DecoratedBox(

                  child: Text(
                    "Producto : " + barcode,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue[100], style: BorderStyle.solid,),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                      margin: const EdgeInsets.all(30.0),
                      padding: const EdgeInsets.all(30.0),
                      
            ),
          ],
        ),
      ),
    );
  }

  Future barcodeScanning() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() {
        model.fetchProducts();
        this.barcode = model.check(barcode);
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
