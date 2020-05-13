import 'package:flutter/material.dart';

class Gridsubscripe extends StatefulWidget {
  @override
  _GridsubscripeState createState() => _GridsubscripeState();
}

class _GridsubscripeState extends State<Gridsubscripe> {
  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Container(
            width: a.width,
            height: a.width / 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
              Icon(Icons.label_outline,color: Colors.white,size: a.width/20,),
              Text("กำลังติดตาม | สแครปยอดนิยม",style: TextStyle(color: Colors.white,fontSize: a.width/20),),
              Icon(Icons.history,color: Colors.white,size: a.width/20)
            ],),
          )
        ],
      ),
    );
  }
}
