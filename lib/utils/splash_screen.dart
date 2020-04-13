import 'package:flutter/material.dart';
import 'package:popcorn/utils/loading_widget.dart';

import 'logo.dart';

/// This is the splash screen of the app
class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        children: <Widget>[
          //Logo
          Expanded(
            child: Logo(
              size: width * 0.5,
            ),
          ),
          SizedBox(
            height: 50,
          ),
          // loading widget
          Container(
              height: 50,
              width: double.maxFinite,
              child: LoadingWidget(
                size: 50,
              )),
          Spacer(),
        ],
      ),
    );
  }
}
