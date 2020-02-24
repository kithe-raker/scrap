import 'package:flutter/material.dart';
import 'package:scrap/widget/Toast.dart';

class Sorry extends StatefulWidget {
  @override
  _SorryState createState() => _SorryState();
}

class _SorryState extends State<Sorry> {
  int check = 0;
  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'กำลังปรับปรุงระบบ',
              style: TextStyle(
                  fontSize: a.width / 6.5,
                  color: Colors.white,
                  fontWeight: FontWeight.w300),
              textAlign: TextAlign.center,
            ),
            Text(
              'เกิดข้อผิดพลาดของระบบ\nแตะปุ่มด้านล่างเพื่อเป็นกำลังใจให้เรา',
              style: TextStyle(
                  fontSize: a.width / 17,
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                  fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: a.height / 10),
            InkWell(
              borderRadius: BorderRadius.circular(a.width),
              child: Container(
                width: a.width / 3.5,
                height: a.width / 6.5,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(a.width)),
                alignment: Alignment.center,
                child: Icon(
                  Icons.favorite,
                  color: Color(0xff26A4FF),
                ),
              ),
              onTap: () async {
                if (check == 0) {
                  Taoast().toast('ขอบคุณนะ');
                  check = check + 1;
                } else if (check == 1) {
                  Taoast().toast('เขินจัง');
                  check = check + 1;
                } else if (check == 2) {
                  Taoast().toast('เยอะไปแล้วนะ');
                  check = check + 1;
                } else if (check == 3) {
                  Taoast().toast('โอเค รู้แล้ว');
                  check = check + 1;
                } else if (check == 4) {
                  Taoast().toast('พอได้แล้ว');
                  check = check + 1;
                } else if (check == 5) {
                  Taoast().toast('พอ...');
                  check = check + 1;
                } else if (check == 6) {
                  Taoast().toast('บอกให้พอไง');
                  check = check + 1;
                } else if (check >= 7) {
                  Taoast().toast('เอาที่สบายใจละกัน');
                  check = check + 1;
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
