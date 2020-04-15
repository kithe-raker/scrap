import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  int page = 0;

  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Scaffold(
        body: Column(
      children: <Widget>[
        Container(
          width: a.width,
          height: a.width / 6,
          color: Colors.black,
          child: Row(
            children: <Widget>[],
          ),
        ),
        Stack(
          children: <Widget>[
            pageBody(page),
            Container(
              child: Column(
                children: <Widget>[
                  Container(
                    width: a.width,
                    height: a.width / 5,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[bink(0), bink(1), bink(1)],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: a.height / 1.6546),
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(
                              bottom: a.width / 18, left: a.width / 2),
                          width: a.width / 2.5,
                          height: a.width / 8,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(a.width)),
                        ),
                        Container(
                          width: a.width,
                          height: a.width / 5,
                          color: Colors.black,
                          child: Stack(
                            children: <Widget>[
                              InkWell(
                                child: Container(
                                  width: a.width / 6,
                                  height: a.width / 6,
                                  color: Colors.white,
                                  alignment: Alignment.center,
                                  child: Container(
                                    color: Colors.green,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DD(),
                                      ));
                                },
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        )
      ],
    ));
  }

  bink(int iint) {
    Size a = MediaQuery.of(context).size;
    return InkWell(
      child: Container(
        margin: EdgeInsets.only(top: a.width / 20, left: a.width / 40),
        width: a.width / 2.5,
        height: a.width / 6,
        decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(a.width / 40)),
      ),
      onTap: () {
        setState(() {
          page = iint;
        });
      },
    );
  }

  Widget pageBody(int selec) {
    switch (selec) {
      case 0:
        Size a = MediaQuery.of(context).size;
        return Container(
          width: a.width,
          height: a.height / 1.1,
          color: Colors.green,
        );
        break;
      case 1:
        Size a = MediaQuery.of(context).size;
        return Container(
          width: a.width,
          height: a.height / 1.1,
          color: Colors.red,
        );
        break;
    }
  }
}

class DD extends StatefulWidget {
  @override
  _DDState createState() => _DDState();
}

class _DDState extends State<DD> {
  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Scaffold(
      //ตรงที่ slide
      drawer: Container(
        width: a.width,
        height: a.height,
        color: Colors.black,
      ),
    );
  }
}
