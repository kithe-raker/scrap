
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
                .collection("blockList")
                .document(widget.userUID)
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
