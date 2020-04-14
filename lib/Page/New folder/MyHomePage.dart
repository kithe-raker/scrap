import 'package:flutter/material.dart';
import 'package:scrap/Page/NewWorld.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int page = 0;
  var _pages = [Page1(), Page2(), Page3()];
  @override
  Widget build(BuildContext context) {
    return PageView(
      onPageChanged: (int index) => setState(() => page = index),
      physics: page >= 0 ? null : NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      children: _pages,
    );
  }
}

class Page1 extends StatefulWidget {
  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  @override
  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: <Widget>[
          GestureDetector(
            onPanEnd: (event) {
              this.setState(() {
                // show = false;
              });
            },
            child: Container(
              width: a.width,
              height: 100,
              color: Colors.red,
            ),
          ),
          Container(
            width: a.width,
            height: a.height - 100,
            color: Colors.blue,
          ),
        ],
      ),
    );
  }
}

class Page2 extends StatefulWidget {
  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  int _index = 0;
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
      body: Column(
        children: <Widget>[
          Container(
            width: a.width,
            height: a.height / 2,
            color: Colors.green,
            child: PageView.builder(
              itemCount: 3,
              controller: PageController(viewportFraction: 1),
              onPageChanged: (int index) => setState(() => _index = index),
              itemBuilder: (context, i) {
                return Transform.scale(
                  scale: i == _index ? 1 : 0.9,
                  child: InkWell(
                    child: Card(
                        color:
                            i == _index ? Color(0xff101010) : Color(0xff2E2E2E),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: i == _index
                                  ? Color(0xff515151)
                                  : Color(0x00fff),
                              width: 0.25,
                            ),
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Image.asset(
                              'assets/paper-mini01.png',
                              width: a.width / 9.5,
                            ),
                          ),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'โลกหลัก',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                                Text(
                                  '{ SCRAP }',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                )
                              ])
                        ])
                        // Center(
                        //   child: Text(
                        //     "Card ${i + 1}",
                        //     style: TextStyle(
                        //         fontSize: 32, color: Colors.white),
                        //   ),
                        // ),
                        ),
                  ),
                );
              },
            ),
          ),
          GestureDetector(
            onVerticalDragDown: (details) {
              print('DragDown: $details');
            },
            child: Container(
              height: a.height / 3,
              width: a.width,
              color: Colors.black,
            ),
          )
        ],
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
