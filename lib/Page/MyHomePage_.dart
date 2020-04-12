import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _pages = [Page1(), Page2(), Page3()];
  @override
  Widget build(BuildContext context) {
    return Page1();
    // PageView(
    //   scrollDirection: Axis.vertical,
    //   children: _pages,
    // );
  }
}

class Page1 extends StatefulWidget {
  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Scaffold(
      body: GestureDetector(
        onVerticalDragUpdate: (details) {
          if (details.delta.dy > 10) {
            Navigator.pop(context);
          }
          print(details.delta.dy);
        },
        child: Container(
          width: a.width,
          height: a.height,
          color: Colors.red,
        ),
      ),
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
    Size a = MediaQuery.of(context).size;
    return Scaffold(
      drawer: Container(
        width: a.width,
        height: a.height,
        color: Colors.white,
      ),
      endDrawer:
          Container(width: a.width, height: a.height, color: Colors.black),
      body: Container(
        width: a.width,
        height: a.height,
        color: Colors.green,
      ),
    );
  }
}

class Page3 extends StatefulWidget {
  @override
  _Page3State createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: a.width,
        height: a.height,
        color: Colors.blue,
      ),
    );
  }
}

class Page4 extends StatefulWidget {
  @override
  _Page4State createState() => _Page4State();
}

class _Page4State extends State<Page4> {
  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: a.width,
        height: a.height,
        color: Colors.yellow,
      ),
    );
  }
}
