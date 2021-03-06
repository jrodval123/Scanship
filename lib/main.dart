import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scoped_model/scoped_model.dart';
import './pages/scan.dart';
import './pages/products.dart';
import './scoped-models/product.dart';
import 'pages/product_list.dart';

void main() => runApp(MyApp());

const MaterialColor white = const MaterialColor(
  0xFFFFFFFF,
  const <int, Color>{
    50: const Color(0xFFFFFFFF),
    100: const Color(0xFFFFFFFF),
    200: const Color(0xFFFFFFFF),
    300: const Color(0xFFFFFFFF),
    400: const Color(0xFFFFFFFF),
    500: const Color(0xFFFFFFFF),
    600: const Color(0xFFFFFFFF),
    700: const Color(0xFFFFFFFF),
    800: const Color(0xFFFFFFFF),
    900: const Color(0xFFFFFFFF),
  },
);

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScopedModel<ProductModel>(
      model: ProductModel(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(primarySwatch: Colors.yellow, fontFamily: 'Roboto'),
        debugShowCheckedModeBanner: false,
        home: MyHomePage(
          title: "Scanship",
        ),
        routes: {
          './home': (BuildContext context) => MyHomePage(),
          './scan': (BuildContext context) => Scan(ProductModel()),
          './products': (BuildContext context) => Products(ProductModel()),
          './product-list': (BuildContext context) => ProductListPage()
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          elevation: 0.0,
          // centerTitle: false,
          title: Text(
            'Scanship',
            style: TextStyle(fontSize: 36, letterSpacing: 2.0),
          ),
          // bottom: PreferredSize(
          //     preferredSize: Size.fromHeight(50.0),
          //     child: Container(
          //       alignment: Alignment(-1.0, -1.0),
          //       padding: EdgeInsets.all(8.0),
          //       child: Text(
          //         'Scanship',
          //         style: TextStyle(fontSize: 36, letterSpacing: 2.0),
          //       ),
          //     )),
        ),
      ),
      body: GridView.count(
        padding: EdgeInsets.only(top: 8.0),
        shrinkWrap: true,
        crossAxisCount: 2,
        children: <Widget>[
          GestureDetector(
            child: Card(
              elevation: 3.0,
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
                    'Procesos',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  )
                ],
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Scan(ProductModel())));
            },
          ),
          GestureDetector(
            child: Card(
              elevation: 3.0,
              child: Column(
                children: <Widget>[
                  Container(
                      child: Image.network(
                    'http://cdn.onlinewebfonts.com/svg/img_391856.png',
                    height: 100.0,
                    width: 400.0,
                    fit: BoxFit.contain,
                  )),
                  SizedBox(
                    height: 30.0,
                  ),
                  Text(
                    'Productos',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  )
                  // Text('Productos')
                ],
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Products(ProductModel())));
              ProductModel().fetchProducts();
            },
          ),
        ],
      ),
    );
  }
}
