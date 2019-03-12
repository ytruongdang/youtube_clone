import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final FocusScopeNode focusScopeNode = FocusScopeNode();

  @override
  void dispose() {
    focusScopeNode.detach();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: false,
      child: FocusScope(
        child: Container(
          color: Colors.greenAccent,
          height: 100.0,
          child: Center(
            child: FlatButton(
              child: Text("Close page"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        autofocus: true,
        node: focusScopeNode,
      ),
    );
  }
}