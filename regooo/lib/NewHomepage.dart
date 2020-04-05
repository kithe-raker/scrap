import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _page = [Page1(),Page2()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: _page,
      ),
    );
  }
}

class Page1 extends StatefulWidget {
  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  @override
  Widget build(BuildContext context) {
    Size a =MediaQuery.of(context).size;
    return Scaffold(
      body: Container(width: a.width,height: a.height,color: Colors.green,),
    );
  }
}

class Page2 extends StatefulWidget {
  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  @override
  Widget build(BuildContext context) {
   Size a =MediaQuery.of(context).size;
    return Scaffold(
      body: Container(width: a.width,height: a.height,color: Colors.red),
    );
  }
}
