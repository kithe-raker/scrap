import 'package:flutter/material.dart';
import 'package:scrap/function/authentication/AuthenService.dart';

class TestT extends StatefulWidget {
  @override
  _TestTState createState() => _TestTState();
}

class _TestTState extends State<TestT> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Text('data'),
        ),
        onTap: () {
          authService.signOut(context);
        },
      ),
    );
  }
}

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class SecondPage extends StatefulWidget {
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage>
    with AutomaticKeepAliveClientMixin {
  int count = 0;

  void add() {
    setState(() {
      count++;
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    print('second initState');
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        body: Center(
            child: Text('Second: $count', style: TextStyle(fontSize: 30))),
        floatingActionButton: FloatingActionButton(
          onPressed: add,
          child: Icon(Icons.add),
        ));
  }
}
