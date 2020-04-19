import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:popcorn/ui/movie_lable.dart';
import 'package:popcorn/utils/app_drawer.dart';
import 'package:popcorn/controllers/watched_provider.dart';

/// This entry point is used for the user interface of the watch list page
class WatchedList extends StatefulWidget {
  @override
  _WatchedListState createState() => _WatchedListState();
}

class _WatchedListState extends State<WatchedList> {
  WatchedProvider _watchedProvider = WatchedProvider();
  Future watchedMovieList;

  /// Accessing the remove movie method from the watch list
  deleteLable(movieId) {
    _watchedProvider.removeWatchedMovies(movieId);
    setState(() {
      this.watchedMovieList = _watchedProvider.getWatchedMovies();
    });
  }

  @override
  Widget build(BuildContext context) {
    this.watchedMovieList = _watchedProvider.getWatchedMovies();

    return AppDrawer(
        pageName: PageName.watchList,
        child: Column(children: <Widget>[
//          Text(
//            "Swap To remove Items",
//            style: TextStyle(color: Colors.grey),
//          ),
          FutureBuilder(
              future: watchedMovieList,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Expanded(child: SpinKitFoldingCube(size: 50,color: Theme.of(context).primaryColor,));
                if (snapshot.data.documents.length == 0) {
                  return Expanded(
                    child: Center(
                        child: Text(
                      "No Watched Movies",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    )),
                  );
                }

                return Expanded(
                  child: ListView.builder(
                      padding: EdgeInsets.only(top: 0),
                      itemCount: snapshot.data.documents.length,
//                    physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (_, int index) {
                        print(snapshot.data.documents[index]);
                        final id = snapshot.data.documents[index]['movieId']
                            .toString();
                        final name = snapshot.data.documents[index]['title'];
                        final poster = snapshot.data.documents[index]['poster'];
                        final vote = snapshot.data.documents[index]['vote'];
                        final release =
                            snapshot.data.documents[index]['release'];
//                    print(snapshot.data.documents[index]['poster'].toString());
                        return Dismissible(
                          key: new Key(index.toString()),
                          onDismissed: (direction) {
                            _watchedProvider.removeWatchedMovies(id);
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
                              favOrWatched: false,
                              delete: deleteLable),
                        );
//                    return Text(snapshot.data.documents[index]['poster'].toString()); //I just assumed that your ChatMessage class takes a parameter message text
                      }),
                );
              }),
//        StreamBuilder<QuerySnapshot>(
//            stream: _watchedProvider.setMovieStream(),
//            builder: (context, snapshot){
//              print(snapshot.data.documents[0]['id']);
//              if (!snapshot.hasData){
//                return Text("No data");
//              }else{
//                return Expanded(
////                height: 200,
//                  child: ListView.builder(
//                      itemCount: snapshot.data.documents.length,
////                    physics: NeverScrollableScrollPhysics(),
//                      itemBuilder: (_, int index) {
//                        print(snapshot.data.documents[index]);
//                      final id = snapshot.data.documents[index]['id'];
//                      final name = snapshot.data.documents[index]['title'];
//                      final poster = snapshot.data.documents[index]['poster'];
//                      final vote = snapshot.data.documents[index]['vote'];
//                      final release = snapshot.data.documents[index]['release'];
////                    print(snapshot.data.documents[index]['poster'].toString());
//                      return MovieLabel(id: id,movieName: name,poster: poster,vote: vote, release: release, favOrWatched: true, delete: deleteLable );
//                        return Text('klkl'); //I just assumed that your ChatMessage class takes a parameter message text
//                      }
//                  ),
//                );
//              }
//
////              return Text("No kdata");
//
//
//            }
//        ),
        ]));
  }
}
