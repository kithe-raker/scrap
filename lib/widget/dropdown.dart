import 'package:flutter/material.dart';

class Dropdown01 extends StatefulWidget {
  final String textt;
  final Function click;
  Dropdown01({
    @required this.textt,
    @required this.click
  });
  @override
  _Dropdown01State createState() => _Dropdown01State();
}

class _Dropdown01State extends State<Dropdown01> {
  int txt = 0;
  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return InkWell(
      child: Container(
        height: a.width / 10,
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(width: a.width / 1000, color: Colors.grey))),
        child: Row(
          children: <Widget>[
            Text(
              widget.textt,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
      onTap: widget.click,
    );
  }
}
