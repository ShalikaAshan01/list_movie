import 'dart:io' show Platform;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:popcorn/controllers/movie_provider.dart';
import 'package:popcorn/models/cast_model.dart';
import 'package:popcorn/models/movie_model.dart';
import 'package:popcorn/models/popular_movie_model.dart';
import 'package:popcorn/utils/loading_widget.dart';

class ViewMovie extends StatefulWidget {
  final int movieId;

  const ViewMovie({Key key, this.movieId}) : super(key: key);

  @override
  _ViewMovieState createState() => _ViewMovieState();
}

class _ViewMovieState extends State<ViewMovie> {
  MovieModel _movie;
  bool _loading;
  MovieProvider _movieProvider = MovieProvider();
  List<CastModel> _castList = List();
  List<PopularMovieInformation> _recommendationList = List();

  @override
  void initState() {
    super.initState();
    _loading = true;
    _init();
  }

  /// This method will call every fetch methods async, because initState is not async
  Future _init() async {
    MovieModel movieModel = await _getMovie();
    List<CastModel> castList = await _getCastList();
    List<PopularMovieInformation> recommendationList = await _getRecommendation();
    setState(() {
      _loading = false;
      _movie = movieModel;
      _castList = castList;
      _recommendationList = recommendationList;
    });
  }

  /// Fetch movie using movie provider
  Future<MovieModel> _getMovie() {
    return _movieProvider.getModvie(widget.movieId);
  }

  /// get cast list related to the movie
  Future<List<CastModel>> _getCastList() {
    return _movieProvider.getCastList(widget.movieId);
  }

  ///fetch movie recommendations related to the movie
  Future<List<PopularMovieInformation>> _getRecommendation()async{
    final result =await _movieProvider.getMovieRecommendations(widget.movieId);
    return result.movieInformations;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.height;

    return Scaffold(
      body: _loading
          ? LoadingWidget()
          : SingleChildScrollView(
              child: Stack(
                children: <Widget>[
                  //poster
                  Container(
                      height: height,
                      width: double.maxFinite,
                      child: CachedNetworkImage(
                        placeholder: (context, url) => LoadingWidget(),
                        fit: BoxFit.cover,
                        imageUrl:
                            "https://image.tmdb.org/t/p/w500/${_movie.posterPath}",
                      )),
                  //back button
                  SafeArea(
                    child: Container(
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Platform.isIOS
                            ? Icons.arrow_back_ios
                            : Icons.arrow_back),
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.topRight,
                    width: double.maxFinite,
                    margin: EdgeInsets.only(
                        top: height * 0.25, right: width * 0.03),
                    child: InkWell(
                      onTap: () {},
                      child: Material(
                        color: Colors.white,
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Icon(Icons.favorite,color: Colors.pinkAccent,size: 30,),
                          )),
                    ),
                  ),
                  //body
                  _buildBody()
                ],
              ),
            ),
    );
  }

  // this method will build the contents
  Widget _buildBody() {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.height;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      margin: EdgeInsets.only(top: height * 0.35),
      padding: const EdgeInsets.all(12),
      width: double.infinity,
      constraints: BoxConstraints(minHeight: height - height * 0.35),
      decoration: BoxDecoration(
          color: _isDarkMode() ? Color(0xFF15233D) : Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(35), topRight: Radius.circular(35))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          //top row
          Container(
            height: width * 0.04,
            alignment: Alignment.center,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: _categoryList(),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.playlist_add),
                )
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          //movie name
          Text(
            _movie.originalTitle,
            style: textTheme.headline5
                .copyWith(fontWeight: FontWeight.bold, fontSize: width * 0.035),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            _movie.tagline,
            style: textTheme.headline3.copyWith(
                fontSize: width * 0.022,
                color: Colors.grey,
                fontStyle: FontStyle.italic),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            "Story",
            style: textTheme.headline6
                .copyWith(fontWeight: FontWeight.bold, fontSize: width * 0.027),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            _movie.overview,
            style: TextStyle(fontSize: width * 0.02),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            "Cast",
            style: textTheme.headline6
                .copyWith(fontWeight: FontWeight.bold, fontSize: width * 0.027),
          ),
          SizedBox(
            height: 15,
          ),
          Container(height: 220, child: _buildCastList()),
          SizedBox(
            height: 15,
          ),
          Text(
            "Recommendations",
            style: textTheme.headline6
                .copyWith(fontWeight: FontWeight.bold, fontSize: width * 0.027),
          ),
          SizedBox(
            height: 15,
          ),
          Container(height: 220, child: _buildRecommendationList()),
        ],
      ),
    );
  }

  //This method will build category list from array
  Widget _categoryList() {
    int length = _movie.genres.length;
    if (length > 3) length = length;
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: length + 2,
        itemBuilder: (context, index) {
          if (index == length)
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Text(
                  "IMDb",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              color: Color(0xFFF6C61A),
            );
          if (index == length + 1)
            return Container(
              padding: const EdgeInsets.only(left: 5),
              alignment: Alignment.center,
              child: Text(
                _movie.voteAverage.toString(),
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Color(0xFFF6C61A)),
              ),
            );
          return _categoryItem(_movie.genres[index]);
        });
  }

  ///This widget used to build category items
  Widget _categoryItem(Genres genres) {
    return Card(
      color: _isDarkMode() ? Colors.white : Colors.white54,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Text(
          genres.name,
          style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.035,
              color: Colors.black,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  ///build cast list
  Widget _buildCastList() {
    return ListView.builder(
      itemCount: _castList.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) => _castItem(_castList[index]),
    );
  }

  /// cast list item
  Widget _castItem(CastModel cast) {
    String placeholder = "assets/images/female_placeholder.png";
    if (cast.gender == 2) placeholder = "assets/images/male_placeholder.png";

    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Card(
            elevation: 10,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: FadeInImage(
                  height: 130,
                    width: 100,
                    fit: BoxFit.cover,
                    placeholder: AssetImage(placeholder),
                    image: NetworkImage("https://image.tmdb.org/t/p/w500/${cast.profilePath}")
                ),
              )),
          Padding(
            padding: const EdgeInsets.only(left:8.0,top: 6),
            child: Text(cast.character,style: textTheme.headline6.copyWith(fontSize: 14),),
          ),
          Expanded(child: Padding(
            padding: const EdgeInsets.only(left:8.0),
            child: Text(cast.name,style: textTheme.headline4.copyWith(fontSize: 14,fontWeight: FontWeight.bold),),
          )),
        ],
      ),
    );
  }

  ///build Recommendation list
  Widget _buildRecommendationList() {
    return ListView.builder(
      itemCount: _recommendationList.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) => _recommendationItem(_recommendationList[index]),
    );
  }

  /// Recommendation list item
  Widget _recommendationItem(PopularMovieInformation movie) {

    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: ()=>Navigator.push(context, MaterialPageRoute(
        builder: (context)=> ViewMovie(movieId: movie.id,)
      )),
      child: Container(
        width: 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Card(
              elevation: 10,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: FadeInImage(
                    height: 130,
                      width: 100,
                      fit: BoxFit.cover,
                      placeholder: AssetImage("assets/images/movie_placeholder.png"),
                      image: NetworkImage("https://image.tmdb.org/t/p/w500/${movie.posterPath}")
                  ),
                )),
            Padding(
              padding: const EdgeInsets.only(left:8.0,top: 6),
              child: Text(movie.originalTitle,style: textTheme.headline6.copyWith(fontSize: 14),),
            ),
          ],
        ),
      ),
    );
  }

  /// get theme mode
  bool _isDarkMode() {
    return Theme.of(context).brightness == Brightness.dark;
  }
}
