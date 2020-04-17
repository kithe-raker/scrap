import 'package:flutter/material.dart';

class Nav {
  pop(context) {
    Navigator.pop(
      context,
    );
  }

  push(context, page) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
  }

  pushReplacement(context, page) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
  }
}
