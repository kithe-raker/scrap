import 'dart:ui';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Container(
      width: a.width,
      height: a.height,
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: <Widget>[
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 9, sigmaY: 9),
                child: Container(
                  color: Colors.black.withOpacity(0.1),
                ),
              ),
              Center(
                child: Container(
                  width: a.width / 3.6,
                  height: a.width / 3.6,
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.42),
                      borderRadius: BorderRadius.circular(12)),
                  child: FlareActor(
                    'assets/loadingpaper.flr',
                    animation: 'Untitled',
                    fit: BoxFit.cover,
                  ),
                ),
              )
            ],
          )),
    );
  }
}
