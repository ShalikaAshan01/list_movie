import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:list_movie/controllers/auth_provider.dart';
import 'package:list_movie/ui/MyInheritedWidget.dart';
import 'package:list_movie/ui/dummy_home.dart';
import 'package:list_movie/ui/login_page.dart';
import 'package:list_movie/utils/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //App run only in portrait mode
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyInheritedWidget(
      child: MyApp(),
    ));
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PoP Corn',
themeMode: MyInheritedData.of(context).darkMode? ThemeMode.dark: ThemeMode.light,
theme: MyInheritedData.of(context).darkMode?ThemeData.dark():ThemeData.light(),
//      theme: ThemeData(
//        brightness: Brightness.light,
//        primarySwatch: Colors.blue,
//        dialogTheme: DialogTheme(
//          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
//        )
//      ),
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
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>DummyHome()));
      else
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>DummyHome()));
    });
    return SplashScreen();
  }
}

