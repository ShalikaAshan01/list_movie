import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyInheritedWidget extends StatefulWidget {
  final Widget child;
  const MyInheritedWidget({Key key, this.child}) : super(key: key);
  @override
  _MyInheritedWidgetState createState() => _MyInheritedWidgetState();
}

class _MyInheritedWidgetState extends State<MyInheritedWidget> {
  bool _darkMode;

  @override
  void initState() {
    super.initState();
    _darkMode = false;
    _getTheme();
  }

  ///This method gets saved darkMode which is saved in shared preferences
  Future _getTheme()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool dark= preferences.getBool("darkMode");
    if(dark==null){
      setState(() {
        _darkMode = false;
      });
    }else{
      setState(() {
        _darkMode = dark;
      });
    }
  }

  /// This mode will change the current theme mode
  void _changeTheme(bool dark)async{
    setState(() {
      _darkMode = dark;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool("darkMode", dark);
  }

  @override
  Widget build(BuildContext context) {
    return MyInheritedData(
      darkMode: _darkMode,
      child: widget.child,
      themeChange: _changeTheme,
    );
  }
}

class MyInheritedData extends InheritedWidget {
  final bool darkMode;
  final ValueChanged<bool> themeChange;
  const MyInheritedData({
    Key key,
    @required Widget child,
    this.darkMode, this.themeChange,
  })  : assert(child != null),
        super(key: key, child: child);

  static MyInheritedData of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MyInheritedData>();;
  }


  @override
  bool updateShouldNotify(MyInheritedData old) {
    return old.darkMode != darkMode || old.themeChange != themeChange;
  }
}