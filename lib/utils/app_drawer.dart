import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:popcorn/controllers/auth_provider.dart';
import 'package:popcorn/ui/my_inherited_widget.dart';
import 'package:popcorn/ui/favourite_list.dart';
import 'package:popcorn/ui/home_page.dart';
import 'package:popcorn/ui/login_page.dart';
import 'package:popcorn/ui/watched_list.dart';

/// Provide a hidden notification drawer for the app
class AppDrawer extends StatefulWidget {
  final Widget child;
  final PageName pageName;
  final String title;

  const AppDrawer(
      {Key key, @required this.child, @required this.pageName, this.title = ""})
      : super(key: key);

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  bool _collapsed = true;
  final _duration = Duration(milliseconds: 500);
  static String _displayName = "";
  static String _profileUrl = "";
  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (_displayName == null ||
        _profileUrl == null ||
        _displayName.isEmpty ||
        _profileUrl.isEmpty) {
      _fetchUserData();
    }
  }

  ///This method will get logged firebase user's display name and profile picture
  void _fetchUserData() async {
    AuthProvider authProvider = AuthProvider();
    final user = await authProvider.getUser();
    String name = user.displayName;
    if (name == null || name.isEmpty) name = "User";

    String photo = md5.convert(utf8.encode(user.email)).toString();
    photo = "https://www.gravatar.com/avatar/$photo";
    setState(() {
      _displayName = name;
      _profileUrl = photo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[_menuItem(), _body()],
      ),
    );
  }

  /// build the main widget(ui)
  Widget _body() {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    return AnimatedPositioned(
        top: _collapsed ? 0 : 0.2 * height,
        bottom: _collapsed ? 0 : 0.2 * width,
        left: _collapsed ? 0 : 0.6 * width,
        right: _collapsed ? 0 : -0.6 * width,
        duration: _duration,
        child: GestureDetector(
          onHorizontalDragUpdate: (details) {
            if (details.delta.dx >= 0) {
              if (_collapsed)
                setState(() {
                  _collapsed = false;
                });
            } else {
              if (!_collapsed)
                setState(() {
                  _collapsed = true;
                });
            }
          },
          child: AbsorbPointer(
            absorbing: !_collapsed,
            child: Material(
                animationDuration: _duration,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(_collapsed ? 0 : 20)),
                elevation: 10,
                child: Column(
                  children: <Widget>[
                    AnimatedContainer(
                      duration: _duration,
                      padding: EdgeInsets.only(top: _collapsed ? 15 : 0),
                      height: _collapsed ? height * 0.1 : (height * 0.07),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(_collapsed ? 0 : 20)),
                      ),
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: width * 0.04,
                          ),
                          InkWell(
                              onTap: () {
                                setState(() {
                                  _collapsed = !_collapsed;
                                });
                              },
                              child: Icon(
                                Icons.menu,
                                size: width * 0.065,
                                color: Colors.white70,
                              )),
                          Expanded(
                            child: Text(
                              widget.title,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: width * 0.05,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(child: widget.child),
                  ],
                )),
          ),
        ));
  }

  /// Build the navigation drawer menu items
  Widget _menuItem() {
    var activeColor = Colors.black87;
    var deactiveColor = Colors.black54;

    String darkModeText = "Enable Dark Mode";
    bool darkMode = false;
    Color borderShadow = Colors.grey;

    if (Theme.of(context).brightness == Brightness.dark) {
      darkModeText = "Disable Dark Mode";
      activeColor = Colors.white;
      deactiveColor = Colors.white54;
      darkMode = true;
      borderShadow = Colors.black38;
    }

    var activeText = TextStyle(color: activeColor, fontWeight: FontWeight.w500);
    var deactiveText =
        TextStyle(color: deactiveColor, fontWeight: FontWeight.w500);
    final selectedPage = widget.pageName;

    final selectedHome = selectedPage == PageName.home;
    final selectedWatchList = selectedPage == PageName.watchList;
    final selectedFavourite = selectedPage == PageName.favourite;

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
//      mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 50,
          ),
          //Avatar
          Container(
            margin: EdgeInsets.only(left: 23),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: borderShadow, blurRadius: 5.0)]),
            height: 80,
            width: 80,
            child: CachedNetworkImage(
              imageUrl: _profileUrl,
              imageBuilder: (context, image) => InkWell(
                onTap: () => showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: Text("Hello there!"),
                          content: Text(
                              "We used gravatar as the profile picture.Press okay to update the image"),
                          actions: <Widget>[
                            MaterialButton(
                              onPressed: () {
                                ImageCache imagecache = ImageCache();
                                imagecache.clear();
                                _fetchUserData();
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Okay",
                                style: TextStyle(color: Colors.pinkAccent),
                              ),
                            )
                          ],
                        )),
                child: CircleAvatar(
                  backgroundImage: image,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 23, top: 25),
            child: Row(
              children: <Widget>[
                Text(
                  _displayName,
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(
                  width: 15,
                ),
                InkWell(
                    onTap: () => _edit(),
                    child: Icon(
                      Icons.edit,
                      color: deactiveColor,
                      size: 18,
                    ))
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          ListTile(
            onTap: () => _navigate(PageName.home, HomePage()),
            title: Text(
              "Home",
              style: selectedHome ? activeText : deactiveText,
            ),
            leading: Icon(Icons.home,
                color: selectedHome ? activeColor : deactiveColor),
          ),
          ListTile(
            onTap: () => _navigate(PageName.watchList, WatchedList()),
            title: Text("Watch list",
                style: selectedWatchList ? activeText : deactiveText),
            leading: Icon(
              Icons.watch_later,
              color: selectedWatchList ? activeColor : deactiveColor,
            ),
          ),
          ListTile(
            onTap: () => _navigate(PageName.favourite, FavouriteList()),
            title: Text("Favorite",
                style: selectedFavourite ? activeText : deactiveText),
            leading: Icon(Icons.favorite,
                color: selectedFavourite ? activeColor : deactiveColor),
          ),
          ListTile(
            onTap: () => MyInheritedData.of(context).themeChange(!darkMode),
            title: Text(
              darkModeText,
              style: deactiveText,
            ),
            leading: Icon(
              Icons.brightness_high,
              color: deactiveColor,
            ),
          ),
          ListTile(
            onTap: () async {
              await AuthProvider().signOut();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (Route<dynamic> route) => false);
            },
            title: Text(
              "Signout",
              style: deactiveText,
            ),
            leading: Icon(
              Icons.power_settings_new,
              color: deactiveColor,
            ),
          ),
        ],
      ),
    );
  }

  /// This method is used for navigate to another page
  void _navigate(PageName pageName, to) {
    setState(() {
      _collapsed = true;
    });

    if (widget.pageName != pageName) {
      //Navigate to page after animation finish
      Timer(_duration, () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => to));
      });
    }
  }

  /// This method will used to edit users display name
  Future _edit() async {
    await showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
              builder: (context, setState) => AlertDialog(
                title: Text("Edit Display Name"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: _textEditingController,
                      decoration: InputDecoration(hintText: "Enter your name"),
                    ),
                  ],
                ),
                actions: <Widget>[
                  MaterialButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      setState(() {
                        _collapsed = true;
                      });
                      AuthProvider _auth = AuthProvider();
                      await _auth
                          .updateDisplayName(_textEditingController.text);
                      _fetchUserData();
                    },
                    child: Text(
                      "Done",
                      style: TextStyle(color: Colors.pinkAccent),
                    ),
                  )
                ],
              ),
            ));
  }
}

///These are the pages available in app
enum PageName { home, favourite, watchList }
