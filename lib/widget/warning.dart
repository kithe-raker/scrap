import 'package:flutter/material.dart';
import 'package:scrap/Page/profile/Dropdown/ChangePhone.dart';
import 'package:scrap/theme/ScreenUtil.dart';

class Dg {
  warning(BuildContext context, String sub, String text) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: ListTile(
          title: Text(
            text,
            style: TextStyle(fontSize: 20),
          ),
          subtitle: Text(
            sub,
            style: TextStyle(fontSize: 16),
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'ตกลง',
              style: TextStyle(fontSize: 16),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  warning1(BuildContext context, String sub) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: ListTile(
          title: Text(
            "คุณต้องการออกจากหน้านี้ใช่หรือไม่",
            style: TextStyle(fontSize: 20),
          ),
          subtitle: Text(
            sub,
            style: TextStyle(fontSize: 16),
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'ยกเลิก',
              style: TextStyle(fontSize: 16),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text(
              'ตกลง',
              style: TextStyle(fontSize: 16),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ChangePhone()));
            },
          ),
        ],
      ),
    );
  }

  warnDialog(BuildContext context, String warn, Function function) {
    showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            backgroundColor: Colors.white,
            content: Container(
              child: Text(warn),
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('ยกเลิก')),
              FlatButton(onPressed: function, child: Text('ตกลง'))
            ],
          );
        });
  }

  warnDate(BuildContext context, String warn) {
    return showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            backgroundColor: Colors.white,
            content: Container(
              child: Text(warn),
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('ok'))
            ],
          );
        });
  }
}

///warning dialog auto set [load] to false ,When was called
warn(String warning, BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            height: MediaQuery.of(context).size.height / 6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(warning),
                RaisedButton(
                    child: Text('ok'),
                    onPressed: () {
                      Navigator.pop(context);
                    })
              ],
            ),
          ),
        );
      });
}

final String errorTitle = "ข้อผิดพลาด";
final String infoTitle = "คำแนะนำ";

alert(String title, String warning, BuildContext context) {
  // set up the button
  Widget okButton = FlatButton(
    child: Text(
      "ตกลง",
      style: TextStyle(
        fontSize: s34,
      ),
    ),
    onPressed: () {
      // This closes the dialog. `context` means the BuildContext, which is
      // available by default inside of a State object. If you are working
      // with an AlertDialog in a StatelessWidget, then you would need to
      // pass a reference to the BuildContext.
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(
      title,
      style: TextStyle(
        fontSize: s40,
        fontWeight: FontWeight.bold,
      ),
    ),
    content: Text(
      warning,
      style: TextStyle(
        fontSize: s36,
      ),
    ),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
  return '';
}
