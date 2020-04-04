import 'package:flutter/material.dart';

class DummyHome extends StatefulWidget {
  @override
  _DummyHomeState createState() => _DummyHomeState();
}

class _DummyHomeState extends State<DummyHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Replace home"),
      ),
    );
  }
}
