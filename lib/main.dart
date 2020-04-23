import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:popcorn/controllers/auth_provider.dart';
import 'package:popcorn/ui/my_inherited_widget.dart';
import 'package:popcorn/ui/home_page.dart';
import 'package:popcorn/ui/login_page.dart';
import 'package:popcorn/utils/splash_screen.dart';

// Main method of the app
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

// NMaterialApp class of the app
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PoP Corn',
      debugShowCheckedModeBanner: false,
      themeMode: MyInheritedData.of(context).darkMode
          ? ThemeMode.dark
          : ThemeMode.light,
      theme: MyInheritedData.of(context).darkMode
          ? ThemeData.dark().copyWith(primaryColor: Colors.blueGrey)
          : ThemeData.light().copyWith(backgroundColor: Colors.white,primaryColor: Colors.blue),
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

/// This is root page of the app if user is already login to the app redirect to the home page otherwise
/// redirect to the login page
class Root extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = AuthProvider();
    authProvider.getUser().then((value) {
      if (value == null)
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      else
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
    });
    return SplashScreen();
  }
}
