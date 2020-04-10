import 'package:flutter/material.dart';
import 'package:scrap/Page/authenPage/signIn/LoginPage.dart';
import 'package:scrap/function/authServices/authService.dart';

class AuthenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: fireAuth.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            body: Center(
              child: RaisedButton(
                  child: Text('sign out'),
                  onPressed: () {
                    authService.signOut(context);
                  }),
            ),
          );
        } else {
          return LoginPage();
        }
      },
    );
  }
}
