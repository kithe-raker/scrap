
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BlockingList extends StatefulWidget {
  final String userUID;
  BlockingList({@required this.userUID});
    @override
  _BlockingListState createState() => _BlockingListState();
}

class _BlockingListState extends State<BlockingList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: Firestore.instance
                .collection("Users")
                .document(widget.userUID)
                .collection("info")
                .document("blockList")
                .snapshots(),
        builder: (context ,snapshot){
          if(snapshot.hasData)
          {
          List blockList = snapshot.data['blockList'];
          return blockList == null || snapshot.data == null || snapshot.data.length > 0 ?
          nullReturn() : dataReturn(blockList);
          }
          else
            return nullReturn();
        }
      )
    );
  }
  unblockDialog(String writer, String time , String text, String writerUID) {
     showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            content: Container(
              child: Text(
                  'คุณต้องการ\"ปลดบล็อค\" ผู้ใช้นี้ใช่หรือไม่'),
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('ยกเลิก')),
              FlatButton(
                child: Text('ตกลง'),
                onPressed: () async {
                  toast('ทำการปลดบล็อคแล้ว');
                  Navigator.pop(context);
                  Navigator.pop(context);
                  await unblock(writer, time, text,writerUID);
                },
              )
            ],
          );
        });
  }

  unblock(String writer, String time , String text, writerUID) {
    Map unblock = {
      'uid': writerUID,
      'id': writer,
      'text': text,
      'time': time
    };
    await Firestore.instance
        .collection("Users")
        .document(widget.userUID)
        .collection("info")
        .document("blockList")
        .setData({
      'blockList': FieldValue.arrayRemove([unblocked])
    }, merge: true);

  }
  Widget nullReturn(){
    return Text("ไม่มีผู้ใช้ที่โดนบล็อค");
  }

    Widget dataReturn(List blockList){
     return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2,              
              child: ListView.builder(
                itemCount: blockList.length,
                itemBuilder: (context, index){
                  String writer = blockList[index]['id'];
                  String time = blockList[index]['time'];
                  String text = blockList[index]['text'];
                  String writerUID = blockList[index]['uid'];
                  return Container(
                    child: Column(
                      children: <Widget>[
                        
                        Text(writer),
                        Text(time),

                        //unblock btn
                        InkWell(
                                    child: Container(
                                      width: a.width / 3.5,
                                      height: a.width / 6.5,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(a.width),
                                            topRight: Radius.circular(a.width),
                                            bottomRight:
                                                Radius.circular(a.width),
                                            bottomLeft:
                                                Radius.circular(a.width),
                                          )),
                                      alignment: Alignment.center,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            Icons.not_interested,
                                            color: Colors.red,
                                          ),
                                          Text(
                                            "ปลดบล็อค",
                                            style: TextStyle(
                                              fontSize: a.width / 15,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      unblockDialog(writer,time,text,writerUID);
                                      //dialogPa(writerID, writer);
                                    },
                                  ),
                      
                        Text(text),
                        Text(writerUID),
                      ],
                    ),
                  );
                }
              )
     );
  }
}
