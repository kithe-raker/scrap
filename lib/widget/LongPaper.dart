import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LongPaper extends StatefulWidget {
  final Map scrap;
  final String uid;
  LongPaper({@required this.scrap, @required this.uid});
  @override
  _LongPaperState createState() => _LongPaperState();
}

class _LongPaperState extends State<LongPaper> {
  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Container(
        margin: EdgeInsets.only(right: a.width / 15, top: a.width / 20),
        width: a.width / 1.5,
        height: a.width / 2.3,
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            image: AssetImage('assets/paper-readed.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(a.width / 40),
              width: a.width,
              height: a.width / 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("เขียนโดย : ${widget.scrap['scap']['writer']}"),
                      Text("เวลา : ${widget.scrap['scap']['time']}"),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    color: Colors.black,
                    iconSize: a.width / 12,
                    onPressed: () async {
                      warning();
                    },
                  )
                ],
              ),
            ),
            Container(
              width: a.width,
              height: a.width,
              alignment: Alignment.center,
              child: Text(
                widget.scrap['scap']['text'],
                style: TextStyle(fontSize: a.width / 15),
              ),
            )
          ],
        ));
  }

  warning() {
    return showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            backgroundColor: Colors.white,
            content: Container(
              child: Text('คุณต้องการลบจริงๆใช่มั้ย'),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('ok'),
                onPressed: () async {
                  Navigator.pop(context);
                  await remove();
                },
              )
            ],
          );
        });
  }

  remove() async {
    await Firestore.instance
        .collection('Users')
        .document(widget.uid)
        .collection('scraps')
        .document('collection')
        .setData({
      'scraps': {
        widget.scrap['id']: FieldValue.arrayRemove([this.widget.scrap['scap']])
      }
    }, merge: true);
  }
}
