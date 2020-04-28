import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:popcorn/controllers/auth_provider.dart';
import 'package:popcorn/ui/movie_lable.dart';
import 'package:popcorn/utils/app_drawer.dart';
import 'package:popcorn/controllers/watched_provider.dart';
import 'package:shimmer/shimmer.dart';

/// This entry point is used for the user interface of the watch list page
class WatchedList extends StatefulWidget {
  @override
  _WatchedListState createState() => _WatchedListState();
}

class _WatchedListState extends State<WatchedList> {
  final GlobalKey<AnimatedListState> _key = GlobalKey();
  WatchedProvider _watchedProvider = WatchedProvider();
  Future watchedMovieList;
  bool _loading = true;
  bool isDeleting = false;
  String _userId;

  /// Accessing the remove movie method from the watch list
  deleteLable(movieId) {
    _watchedProvider.removeWatchedMovies(movieId);
    setState(() {
      this.watchedMovieList = _watchedProvider.getWatchedMovies();
    });
  }

  @override
  void initState() {
    super.initState();
    _getUserID();
  }

  @override
  Widget build(BuildContext context) {
    this.watchedMovieList = _watchedProvider.getWatchedMovies();

    return AppDrawer(
        pageName: PageName.watchList,
        title: 'Watched List',
        child: _loading
            ? _skeletonWidget()
            : StreamBuilder(
                stream: _watchedProvider.getWatchedList(_userId),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData || snapshot.data.documents.length == 0)
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
                  return Stack(children: [
                    ListView.builder(
                        padding: EdgeInsets.only(top: 0),
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (_, int index) {
                          if (snapshot.data == null)
                            return Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Icon(Icons.local_movies),
                                  Text(
                                    "We cannot find any movies",
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  ),
                                ],
                              ),
                            );

                          final id = snapshot.data.documents[index]['movieId']
                              .toString();
                          final name = snapshot.data.documents[index]['title'];
                          final poster =
                              snapshot.data.documents[index]['poster'];
                          final vote = snapshot.data.documents[index]['vote'];
                          final release =
                              snapshot.data.documents[index]['release'];
                          return Dismissible(
                            key: new ValueKey(id),
                            onDismissed: (direction) {
//                            setState(() {
                              _deleteWatchedMovie(int.parse(id));
//                            });

                              Scaffold.of(context).showSnackBar(new SnackBar(
                                  content: Text(
                                    "Movie $name Successfully Removed",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  backgroundColor: Colors.grey[850]));
                            },
                            background: new Container(
                              color: Colors.red,
                              child: Center(
                                child: Icon(
                                  Icons.delete,
                                  size: 50,
                                  color: Colors.grey[200],
                                ),
                              ),
                            ),
                            child: MovieLabel(
                                id: id,
                                movieName: name,
                                poster: poster,
                                vote: vote,
                                release: release,
                                favOrWatched: true),
                          );
                        }),
                  ]);
                },
              ));
  }

  /// fetch logged user id from
  Future _getUserID() async {
    final user = await AuthProvider().getUser();
    setState(() {
      _userId = user.uid;
      _loading = false;
    });
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

  Future<void> _deleteWatchedMovie(int movieID) async {
    await _watchedProvider.removeWatchedMovies(movieID);
  }
}
