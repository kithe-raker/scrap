import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {
  final DocumentSnapshot doc;
  EditProfile({@required this.doc});
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  var _key = GlobalKey<FormState>();
  String id;

  summit(String uid) async {
    List index = [];
    for (int i = 0; i <= id.length; i++) {
      index.add(i == 0 ? id[0] : id.substring(0, i));
    }
    await Firestore.instance
        .collection('Users')
        .document(uid)
        .updateData({'id': id, 'searchIndex': index});
  }

  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        child: Form(
          key: _key,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('ok'),
              inputBox(a, 'ชื่อของคุณ', widget.doc['id']),
              RaisedButton(
                  child: Text('แก้ไข'),
                  onPressed: () async {
                    if (_key.currentState.validate()) {
                      _key.currentState.save();
                      id == widget.doc['id']
                          ? print('nope')
                          : await summit(widget.doc['uid']);
                      Navigator.pop(context);
                      Navigator.pop(context);
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }

  Widget inputBox(Size a, String hint, String value) {
    var tx = TextEditingController();
    tx.text = value;
    return Container(
      width: a.width / 1.3,
      height: a.width / 6,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.black12, borderRadius: BorderRadius.circular(a.width)),
      child: TextFormField(
        controller: tx,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hint,
            labelStyle: TextStyle(color: Colors.white)),
        validator: (val) {
          return val.trim() == "" ? 'put isas' : null;
        },
        onSaved: (val) {
          id = val.trim();
        },
      ),
    );
  }
}
