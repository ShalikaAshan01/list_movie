import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

/// Provides a loading widget for the app (spinner)
class LoadingWidget extends StatelessWidget {
  final double size;

  const LoadingWidget({Key key, this.size = 50}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        alignment: Alignment.center,
        child: SpinKitCircle(
          color: Colors.redAccent,
          size: size,
        ),
      ),
    );
  }
}
