import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:popcorn/controllers/favourite_provider.dart';
import 'package:popcorn/controllers/movie_provider.dart';
import 'package:popcorn/models/movie_model.dart';
import 'package:popcorn/utils/app_drawer.dart';
import 'package:popcorn/utils/loading_widget.dart';
import 'package:shimmer/shimmer.dart';

class FavouriteList extends StatefulWidget {
  @override
  _FavouriteListState createState() => _FavouriteListState();
}

class _FavouriteListState extends State<FavouriteList> {
  List<MovieModel> _movieList = List();
  final _scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  FavouriteProvider _favouriteProvider = FavouriteProvider();
  bool _loading = true;
  @override
  void initState() {
    super.initState();
    _fetchListFromFirebase();
  }

  ///fetch favourite list ids from firebase
  Future _fetchListFromFirebase()async{
    var fav = await _favouriteProvider.getFavouriteList();
    fav = fav.cast<int>();
    List<MovieModel> movies = List();
    fav.forEach((id) async{
      MovieModel movie = await MovieProvider().getModvie(id);
      setState(() {
        _movieList.add(movie);
      });
    });
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldGlobalKey,
      body: AppDrawer(
        pageName: PageName.favourite,
        title: "Favourite",
        child: _buildList(),
      ),
    );
  }

  ///This function will build the favourite list
  Widget _buildList() {
    if(_loading)
      return _skeletonWidget();
    if(_movieList == null || _movieList.length==0)
      return _skeletonWidget();
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: SingleChildScrollView(
        child: ListView.builder(
          reverse: true,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _movieList.length,
            itemBuilder: (context,index)=>_favouriteItem(index)),
      ),
    );
  }

  ///
  /// This is favourite items widget
  Widget _favouriteItem(int index) {
    final movie = _movieList[index];
    final imageURL = "https://image.tmdb.org/t/p/w500/${movie.posterPath}";
    final name = movie.originalTitle;
    String category1 = "N/A";
    if(movie.genres.length>0)
      category1 = movie.genres[0].name;
    String category2 = "";
    if(movie.genres.length>1) {
      category2 = movie.genres[1].name;
    }
    String runtime = "${movie.runtime} minutes";
    if(runtime.toLowerCase().contains("null"))
      runtime = "N/A";
    final rating = movie.voteAverage;

    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    final imageSize = width * 0.2;
    Color brokenColor = Colors.black54;

    var categoryColor = Colors.black54;
    var imdbColor = Colors.black38;
    if(Theme.of(context).brightness == Brightness.dark){
      categoryColor = Colors.white70;
      imdbColor = Colors.grey;
    }

    final nameStyle = textTheme.headline6.copyWith(fontWeight: FontWeight.bold,fontSize: width * 0.042);
    final categoryStyle = TextStyle(fontSize: width * 0.038,fontWeight: FontWeight.bold,color: categoryColor);
    final imdbStyle = TextStyle(fontSize: width * 0.036,fontWeight: FontWeight.bold,color: imdbColor);

    return Dismissible(
      direction: DismissDirection.endToStart,
      key: ValueKey(movie.id),
      onDismissed: (direction){
        if(direction == DismissDirection.endToStart){
          _deleteMovie(name, index);
        }
      },
      background: Container(
        decoration: BoxDecoration(
            color: Colors.redAccent,
          borderRadius: BorderRadius.circular(10)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(Icons.delete,color: Colors.white,),
            SizedBox(width: 5,),
            Text("Remove",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),textAlign: TextAlign.right,),
            SizedBox(width: 20,)
          ],
        ),
      ),
      child: Stack(
        children: <Widget>[
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: <Widget>[
                // image
                Container(
                  height: imageSize * 1.2,
                  width: imageSize,
                  child: CachedNetworkImage(
                    imageUrl: imageURL,
                    alignment: Alignment.center,
                    imageBuilder: (context, image) {
                      return Container(
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: image, fit: BoxFit.cover),
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      );
                    },
                    placeholder: (context, url) => Container(
                      child: LoadingWidget(
                        size: 25,
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                        child: Icon(
                          Icons.broken_image,
                          color: brokenColor,
                        )),
                  ),
                ),
                SizedBox(width: 15,),
                //Content
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(name,style: nameStyle,),
                      SizedBox(height: 5,),
                      Text("$category1| $category2  $runtime",style: categoryStyle,),
                      SizedBox(height: 5,),
                      Text("IMDB $rating",style: imdbStyle,),
                    ],
                  ),
                )
              ],
            ),
          ),
          // buttons
          Positioned(
            bottom: 5,
            right: 5,
            child: Row(
              children: <Widget>[
                InkWell(
                  child: Icon(Icons.playlist_add,color: imdbColor,), onTap: () => _saveToWatchList(name,index),
                ),
                InkWell(
                  child: Icon(Icons.delete,color: imdbColor,), onTap: () => _deleteMovie(name,index),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //this method will remove the item from favourite list
  void _deleteMovie(String name, int index){
    MovieModel temp = _movieList[index];
    _favouriteProvider.addOrRemoveFavourite(temp.id);
    setState(() {
      _movieList.removeAt(index);
    });
    final snackBar = SnackBar(content: Row(
      children: <Widget>[
        Text('$name is removed from the favourite list'),
        Expanded(
          child: MaterialButton(
            onPressed: (){
              _favouriteProvider.addOrRemoveFavourite(temp.id);
              setState(() {
                _movieList.add(temp);
              });
              _scaffoldGlobalKey.currentState.hideCurrentSnackBar();
            },
            child: Text("Undo",style: TextStyle(color: Colors.pinkAccent),),
          ),
        )
      ],
    ));
    _scaffoldGlobalKey.currentState.showSnackBar(snackBar);
  }


  ///This method will add movie to watchlist
  _saveToWatchList(String name, int index) {print("hi");}


  //this is loading widget for the favourite page
  Widget _skeletonWidget() {
    final width = MediaQuery.of(context).size.width;

    return ListView.builder(itemCount: 10,
      itemBuilder: (context,index){
        return Container(
            padding: EdgeInsets.all(8.0),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[400],
              highlightColor: Colors.white,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: width *0.2,
                    height: width *0.2,
                    color: Colors.white,
                  ),
                  SizedBox(width: 10,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 10,
                          width: width * 0.7,
                          color: Colors.white,
                        ),
                        SizedBox(height: 10,),
                        Container(
                          height: 10,
                          width: width * 0.6,
                          color: Colors.white,
                        ),
                        SizedBox(height: 10,),
                        Container(
                          height: 10,
                          width: width * 0.6,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
        );
      },
    );
  }
}
