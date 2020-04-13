import 'package:flutter/material.dart';

/// Provides the widget which contains the logo of the app
class Logo extends StatelessWidget {
  final double size;

  const Logo({Key key, this.size = 50}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    //check the selected theme dark or not and assign neccesary assest path
    final path = Theme.of(context).brightness == Brightness.light
        ? "assets/images/logoWhite.png"
        : "assets/images/logoBlack.png";
    return Container(
      width: size,
      height: size,
      child: Image.asset(path),
    );
  }
}
