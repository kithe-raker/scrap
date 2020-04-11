import 'package:flutter/material.dart';
import 'package:scrap/Page/authenPage/signIn/LoginPage.dart';
import 'package:scrap/function/authServices/authService.dart';
import 'package:scrap/function/cacheManager/cache_UserInfo.dart';

class AuthenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: fireAuth.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                      child: Text('sign out'),
                      onPressed: () {
                        authService.signOut(context);
                      }),
                  RaisedButton(
                      child: Text('print data'),
                      onPressed: () async {
                        print(await CacheUserInfo().getUserInfo());
                      }),
                ],
              ),
            ),
          );
        } else {
          return LoginPage();
        }
      },
    );
  }
}
