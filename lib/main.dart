import 'package:flutter/material.dart';
import './pages/scan.dart';
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
        '/scan': (BuildContext context) => Scan()
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
      drawer: Drawer(
         child: ListView(
           padding: EdgeInsets.zero,
           children: <Widget>[
             DrawerHeader(
               child: Text('Procesos'),
             ),
             ListTile(
               title: Text("Escanear"),
               onTap: (){
                 Navigator.push(context, MaterialPageRoute(builder: (context)=>Scan()));
               },
             ),
             ListTile(
               title: Text("Proceso 2"),
               onTap: (){},
             )
           ],
         ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          ],
        ),
      ),
// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
