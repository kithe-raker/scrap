import 'package:flutter/material.dart';
import 'package:scrap/services/auth.dart';
import 'package:scrap/services/provider.dart';

import 'LoginPage.dart';
import 'mainstream.dart';

class Authen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Auth auth = Provider.of(context).auth;
    return StreamBuilder<String>(
      stream: auth.onAuthStateChanged,
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData) {
          return MainStream();
        } else {
          return LoginPage();
        }
      },
    );
  }
}
