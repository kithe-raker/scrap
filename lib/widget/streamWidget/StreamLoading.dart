import 'package:flutter/material.dart';
import 'package:scrap/widget/LoadNoBlur.dart';
import 'package:scrap/widget/Loading.dart';

class StreamLoading extends StatefulWidget {
  final Stream<bool> stream;
  final bool blur;
  StreamLoading({@required this.stream, this.blur = false});
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
            return status.data
                ? widget.blur ? Loading() : LoadNoBlur()
                : SizedBox();
          } else {
            return SizedBox();
          }
        });
  }
}
