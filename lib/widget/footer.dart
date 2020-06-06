import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter/material.dart';

class Footer extends StatefulWidget {
  @override
  _FooterState createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  @override
  Widget build(BuildContext context) {
    return CustomFooter(builder: (BuildContext context, LoadStatus mode) {
      switch (mode) {
        case LoadStatus.loading:
          return Center(child: CircularProgressIndicator());
          break;
        default:
          return SizedBox();
          break;
      }
    });
  }
}
