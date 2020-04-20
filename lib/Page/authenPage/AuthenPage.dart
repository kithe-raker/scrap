import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrap/Page/authentication/MainLogin.dart';
import 'package:scrap/function/authServices/authService.dart';
import 'package:scrap/function/cacheManager/cache_UserInfo.dart';
import 'package:scrap/provider/authen_provider.dart';

class AuthenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: fireAuth.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return TemporaryPage();
        } else {
          return MainLogin();
        }
      },
    );
  }
}

class TemporaryPage extends StatefulWidget {
  @override
  _TemporaryPageState createState() => _TemporaryPageState();
}

class _TemporaryPageState extends State<TemporaryPage> {
  bool loading = true;

  initUser() async {
    await cacheUser.getUserInfo(context);
    setState(() => loading = false);
  }

  @override
  void initState() {
    initUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authenInfo = Provider.of<AuthenProvider>(context, listen: false);
    return Scaffold(
      body: Center(
        child: loading
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ClipRRect(
                    child: Image.network(
                      authenInfo?.img ??
                          'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                      width: 180,
                      height: 180,
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(500),
                  ),
                  Text(
                    authenInfo?.pName ?? 'ไม่มี',
                    style: TextStyle(fontSize: 21),
                  ),
                  RaisedButton(
                      child: Text('sign out'),
                      onPressed: () {
                        authService.signOut(context);
                      }),
                  RaisedButton(
                      child: Text('print data'),
                      onPressed: () async {
                        var data = await CacheUserInfo().getUserInfo(context);
                        print(data);
                      }),
                ],
              ),
      ),
    );
  }
}
