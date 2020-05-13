import 'package:flutter/material.dart';

class GridSubscripe2 extends StatefulWidget {
  @override
  _GridSubscripe2State createState() => _GridSubscripe2State();
}

class _GridSubscripe2State extends State<GridSubscripe2> {
  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Container(
      child: ListView(
                children: [
                  Container(
                    width: a.width,
                    child: Wrap(
                      children: [
                        block(),
                        block(),
                        block(),
                        block(),
                        block(),
                        block(),
                        block(),
                        block(),
                        
                      ],
                    ),
                  ),
                ],
              ),
    );
  }

  Widget block() {
    Size a = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(top: a.width / 80, left: a.width / 80),
      width: a.width / 2.1,
      height: a.width / 2.1,
      color: Colors.white,
    );
  }
}