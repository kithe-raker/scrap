import 'package:flutter/material.dart';
import 'package:scrap/widget/LoadNoBlur.dart';

class StreamLoading extends StatefulWidget {
  final Stream<bool> stream;
  StreamLoading({@required this.stream});
  @override
  _StreamLoadingState createState() => _StreamLoadingState();
}

class _StreamLoadingState extends State<StreamLoading> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: widget.stream,
        builder: (context, AsyncSnapshot<bool> status) {
          if (status.hasData) {
            return status.data ? LoadNoBlur() : SizedBox();
          } else {
            return SizedBox();
          }
        });
  }
}
