import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

///
/// This widget use as the loading widget
///
class LoadingWidget extends StatelessWidget {
  final double size;

  const LoadingWidget({Key key, this.size=25}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.maxFinite,
        alignment: Alignment.center,
        child: SpinKitCircle(
          color: Colors.redAccent,
          size: size,
        ),
      ),
    );
  }
}
