import 'package:flutter/material.dart';
import './pages/scan.dart';
import './pages/products.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: MyHomePage(title: 'Scanship'),
      routes: {
        '/scan': (BuildContext context) => Scan(),
        '/products': (BuildContext context) => Products()
      },
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
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: <Widget>[
          GestureDetector(
            child: Card(
              child: Text("Escanear"),
            ),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Scan()));
            },
          ),
          GestureDetector(
            child: Card(
              child: Text("Productos"),
            ),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Products()));
            },
          ),
        ],
      )
    );
  }
}
