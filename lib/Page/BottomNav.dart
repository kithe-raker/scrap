import 'package:flutter/material.dart';

class BottomNavDrawer extends StatefulWidget {
  @override
  BottomNavDrawerState createState() {
    return new BottomNavDrawerState();
  }
}

class BottomNavDrawerState extends State<BottomNavDrawer> {
  static final List<String> _listViewData = [
    "Inducesmile.com",
    "Flutter Dev",
    "Android Dev",
    "iOS Dev!",
    "React Native Dev!",
    "React Dev!",
  ];

  _showDrawer() {
    showModalBottomSheet(
        enableDrag: true,
        context: context,
        builder: (context) {
          return Container(
            child: ListView(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _listViewData
                      .map((data) => ListTile(
                            title: Text(data),
                          ))
                      .toList(),
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(" Bottom Nav Drawer Example"),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          height: 50.0,
          child: Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.menu),
                onPressed: _showDrawer,
              )
            ],
          ),
        ),
      ),
      body: Center(
        child: Text('Main Body'),
      ),
    );
  }
}
