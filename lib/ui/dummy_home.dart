import 'package:flutter/material.dart';
import 'package:list_movie/utils/app_drawer.dart';

class DummyHome extends StatefulWidget {
  @override
  _DummyHomeState createState() => _DummyHomeState();
}

class _DummyHomeState extends State<DummyHome> {
  @override
  Widget build(BuildContext context) {
    return AppDrawer(
      pageName: PageName.home,
      child: Center(
        child: Text("home"),
      ),
    );
  }
}
