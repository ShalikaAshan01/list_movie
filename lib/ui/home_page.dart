import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:popcorn/models/popular_movie_model.dart';
import 'package:popcorn/utils/loading_widget.dart';
import 'package:popcorn/controllers/movie_provider.dart';
import 'package:popcorn/utils/app_drawer.dart';
import 'package:popcorn/ui/movie_lable.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _movieProvider = MovieProvider();

  lableFunc(lable){
    print('Lable');
  }
  @override
  Widget build(BuildContext context) {
    return AppDrawer(
      pageName: PageName.home,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.only(bottomRight: Radius.elliptical(75, 50), bottomLeft: Radius.elliptical(75, 50), ),
              child: Container(
                  height: 300.0,
//        width: 300.0,
                  child: Carousel(
                    dotSize: 4.0,
                    dotSpacing: 15.0,
                    showIndicator: false,
//          dotColor: Colors.lightGreenAccent,
                    indicatorBgPadding: 10.0,
//          dotBgColor: Colors.purple.withOpacity(0.5),
                    borderRadius: false,
                    images: [
                      NetworkImage('https://i0.wp.com/www.irishfilmcritic.com/wp-content/uploads/2019/09/Joker.jpg?fit=1392%2C696&ssl=1'),
                      NetworkImage('https://ehpodcasts.files.wordpress.com/2019/04/alfredjhemlockbanner.jpg?w=1280'),
                      NetworkImage('https://wehaveahulk.co.uk/wp-content/uploads/2018/03/Tomb-Raider-2018-Movie-Poster-Background-1920x1200-e1521931120905.jpg'),
                      NetworkImage('https://i.pinimg.com/originals/49/e8/fd/49e8fd8c7ec30dd152db46603c2fb3d0.jpg'),
                      NetworkImage('https://www.shannons.com.au/image-library/news/H56CQ6H4DEDBCC04_large/ford-v-ferrari.jpg'),
//            ExactAssetImage("assets/images/LaunchImage.jpg")
                    ],
                  )
              ),
            ),
            Container(
              child: FutureBuilder(
                future: _movieProvider.fetchPopularMovies(2),
                builder: (context,snapshot){
                  if(!snapshot.hasData)
                    return LoadingWidget();
                  PopularMovieResult result = snapshot.data;
                  List<PopularMovieInformation> list = result.movieInformations;
                  return ListView.builder(
                    padding: EdgeInsets.only(top: 0),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: list.length,
                    itemBuilder: (context,index){
                    final id = "${list[index].id}";
                    final name = list[index].title;
                    final poster = list[index].posterPath;
                    final vote = list[index].voteAverage;
                    final release = list[index].releaseDate;
//                    print(list[index].releaseDate);
                    return MovieLabel(id: id,movieName: name,poster: poster,vote: vote, release: release, favOrWatched: false, delete: lableFunc('lable'),);
                  },);
                },
              ),
            )

          ],
        ),
      ),
    );
  }
}
