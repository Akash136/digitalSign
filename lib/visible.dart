import 'package:flutter/material.dart';

class Visible extends StatefulWidget {
  @override
  _VisibleState createState() => _VisibleState();
}

class _VisibleState extends State<Visible> {
  bool a = true;
  String mText = "Press to hide";

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Visibility",
      home: new Scaffold(
          body: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new RaisedButton(
            onPressed: _visibilitymethod,
            child: new Text(mText),
          ),
          a == true
              ? new Container(
                  width: 300.0,
                  height: 300.0,
                  color: Colors.red,
                )
              : new Container(),
        ],
      )),
    );
  }

  void _visibilitymethod() {
    setState(() {
      if (a) {
        a = false;
        mText = "Press to show";
      } else {
        a = true;
        mText = "Press to hide";
      }
    });
  }
}
