import 'package:flutter/material.dart';

import 'MovieList.dart';
import 'movieLable.dart';

void main() => runApp(MaterialApp(
  home: Home(),
));

class Home extends StatefulWidget {
  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text('Home huththo'),
        backgroundColor: Colors.black87,
        elevation: 0.0,
      ),
      body:  MovieList(),

    );
  }
}


