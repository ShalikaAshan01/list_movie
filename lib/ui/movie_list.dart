import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:popcorn/utils/app_drawer.dart';
import 'package:popcorn/ui/movie_lable.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return AppDrawer(
      pageName: PageName.home,
      title: "Home",
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
                height: 225.0,
//        width: 300.0,
                child: Carousel(
                  dotSize: 4.0,
                  dotSpacing: 15.0,
//          dotColor: Colors.lightGreenAccent,
                  indicatorBgPadding: 10.0,
//          dotBgColor: Colors.purple.withOpacity(0.5),
                  borderRadius: true,
                  images: [
                    NetworkImage(
                        'https://i0.wp.com/www.irishfilmcritic.com/wp-content/uploads/2019/09/Joker.jpg?fit=1392%2C696&ssl=1'),
                    NetworkImage(
                        'https://ehpodcasts.files.wordpress.com/2019/04/alfredjhemlockbanner.jpg?w=1280'),
                    NetworkImage(
                        'https://wehaveahulk.co.uk/wp-content/uploads/2018/03/Tomb-Raider-2018-Movie-Poster-Background-1920x1200-e1521931120905.jpg'),
                    NetworkImage(
                        'https://i.pinimg.com/originals/49/e8/fd/49e8fd8c7ec30dd152db46603c2fb3d0.jpg'),
                    NetworkImage(
                        'https://www.shannons.com.au/image-library/news/H56CQ6H4DEDBCC04_large/ford-v-ferrari.jpg'),
//            ExactAssetImage("assets/images/LaunchImage.jpg")
                  ],
                )),
            MovieLabel(),
            MovieLabel(),
            MovieLabel(),
            MovieLabel(),
          ],
        ),
      ),
    );
  }
}

class MovieListItem extends StatefulWidget {
  @override
  _MovieListItemState createState() => _MovieListItemState();
}

class _MovieListItemState extends State<MovieListItem> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
