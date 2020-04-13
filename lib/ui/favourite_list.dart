import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:popcorn/controllers/auth_provider.dart';
import 'package:popcorn/controllers/favourite_provider.dart';
import 'package:popcorn/controllers/watched_provider.dart';
import 'package:popcorn/models/firebase_movie_model.dart';
import 'package:popcorn/ui/view_movie.dart';
import 'package:popcorn/utils/app_drawer.dart';
import 'package:popcorn/utils/loading_widget.dart';
import 'package:shimmer/shimmer.dart';

/// Provides a User interface for the favourite movies
class FavouriteList extends StatefulWidget {
  @override
  _FavouriteListState createState() => _FavouriteListState();
}

class _FavouriteListState extends State<FavouriteList> {
  final _scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  FavouriteProvider _favouriteProvider = FavouriteProvider();
  bool _loading = true;
  String _userId;

  @override
  void initState() {
    super.initState();
    _getUserID();
  }

  /// fetch logged user id from
  Future _getUserID() async {
    final user = await AuthProvider().getUser();
    setState(() {
      _userId = user.uid;
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
        child: _loading
            ? _skeletonWidget()
            : StreamBuilder(
                stream: _favouriteProvider.getFavouriteList(_userId),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) return _skeletonWidget();
                  return _buildList(snapshot.data.documents);
                },
              ),
      ),
    );
  }

  /// This function will build the favourite list
  Widget _buildList(List<DocumentSnapshot> docs) {
    if (docs == null || docs.length == 0)
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.local_movies),
            Text(
              "We cannot find any movies",
              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
      );
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: SingleChildScrollView(
        child: ListView.builder(
            reverse: true,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: docs.length,
            itemBuilder: (context, index) =>
                _favouriteItem(FirebaseMovieModel.fromMap(docs[index].data))),
      ),
    );
  }

  /// Provide a list item for favourite list
  Widget _favouriteItem(FirebaseMovieModel movie) {
    final imageURL = "https://image.tmdb.org/t/p/w500/${movie.poster}";
    final name = movie.title;
    String category1 = "N/A";
    if (movie.genres.length > 0) category1 = movie.genres[0];
    String category2 = "";
    if (movie.genres.length > 1) {
      category2 = movie.genres[1];
    }
    String runtime = "${movie.runtime} minutes";
    if (runtime.toLowerCase().contains("null")) runtime = "N/A";
    final rating = movie.vote;

    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    final imageSize = width * 0.2;
    Color brokenColor = Colors.black54;

    var categoryColor = Colors.black54;
    var imdbColor = Colors.black38;
    if (Theme.of(context).brightness == Brightness.dark) {
      categoryColor = Colors.white70;
      imdbColor = Colors.grey;
    }

    final nameStyle = textTheme.headline6
        .copyWith(fontWeight: FontWeight.bold, fontSize: width * 0.042);
    final categoryStyle = TextStyle(
        fontSize: width * 0.038,
        fontWeight: FontWeight.bold,
        color: categoryColor);
    final imdbStyle = TextStyle(
        fontSize: width * 0.036, fontWeight: FontWeight.bold, color: imdbColor);

    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ViewMovie(
                  movieId: movie.movieId,
                )));
      },
      child: Dismissible(
        direction: DismissDirection.endToStart,
        key: ValueKey(movie.movieId),
        onDismissed: (direction) {
          if (direction == DismissDirection.endToStart) {
            _deleteMovie(movie);
          }
        },
        background: Container(
          decoration: BoxDecoration(
              color: Colors.redAccent, borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Icon(
                Icons.delete,
                color: Colors.white,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                "Remove",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                textAlign: TextAlign.right,
              ),
              SizedBox(
                width: 20,
              )
            ],
          ),
        ),
        child: Stack(
          children: <Widget>[
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
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
                  SizedBox(
                    width: 15,
                  ),
                  //Content
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          name,
                          style: nameStyle,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "$category1| $category2  $runtime",
                          style: categoryStyle,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "IMDB $rating",
                          style: imdbStyle,
                        ),
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
                  IconButton(
                    icon: Icon(
                      movie.watched
                          ? Icons.playlist_add_check
                          : Icons.playlist_add,
                      color: imdbColor,
                    ),
                    onPressed: () => _saveToWatchList(movie),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: imdbColor,
                    ),
                    onPressed: () => _deleteMovie(movie),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // provide a method for remove movie from favourite list
  Future<void> _deleteMovie(FirebaseMovieModel movie) async {
    movie.favourite = false;

    await _favouriteProvider.addOrRemoveFavourite(movie);

    // display snackbar after removing the movie
    final snackBar = SnackBar(
        content: Row(
      children: <Widget>[
        Expanded(
          child: Text('${movie.title} is removed from the favourite list'),
        ),
        MaterialButton(
          onPressed: () {
            movie.favourite = true;
            _favouriteProvider.addOrRemoveFavourite(movie);
            _scaffoldGlobalKey.currentState.hideCurrentSnackBar();
          },
          child: Text(
            "Undo",
            style: TextStyle(color: Colors.pinkAccent),
          ),
        )
      ],
    ));
    _scaffoldGlobalKey.currentState.showSnackBar(snackBar);
  }

  /// Provide a method for add the movie to watch list
  _saveToWatchList(FirebaseMovieModel movie) {
    WatchedProvider watchedProvider = WatchedProvider();
    if (movie.watched) {
      movie.watched = false;
      watchedProvider.addToWatchedMovies(movie);
    } else {
      movie.watched = true;
      watchedProvider.removeWatchedMovies(movie.movieId);
    }
  }

  // Provides a loading skeleton for the favourite list
  Widget _skeletonWidget() {
    final width = MediaQuery.of(context).size.width;

    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Container(
            padding: EdgeInsets.all(8.0),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[400],
              highlightColor: Colors.white,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: width * 0.2,
                    height: width * 0.2,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 10,
                          width: width * 0.7,
                          color: Colors.white,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 10,
                          width: width * 0.6,
                          color: Colors.white,
                        ),
                        SizedBox(
                          height: 10,
                        ),
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
            ));
      },
    );
  }
}
