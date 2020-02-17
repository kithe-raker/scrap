import 'package:flutter/material.dart';

class AddPlayer extends StatefulWidget {
  @override
  _AddPlayerState createState() => _AddPlayerState();
}

class _AddPlayerState extends State<AddPlayer> {
  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: a.width,
        height: a.height,
        color: Colors.black,
      ),
    );
  }
}
