import 'package:flutter/material.dart';
import 'package:list_movie/controllers/auth_provider.dart';
import 'package:list_movie/ui/dummy_home.dart';
import 'package:list_movie/ui/login_page.dart';
import 'package:list_movie/utils/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PoP Corn',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        dialogTheme: DialogTheme(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
        )
      ),
      home: Root(),
    );
  }
}

class Root extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    AuthProvider authProvider = AuthProvider();
    authProvider.getUser().then((value) {
      //TODO:add home
      if(value == null)
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LogiPage()));
      else
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>DummyHome()));
    });
    return SplashScreen();
  }
}

