import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:popcorn/controllers/watched_provider.dart';
import 'package:popcorn/ui/view_movie.dart';

/// This entry point provides the list  view item for homepage and watchlist
class MovieLabel extends StatefulWidget {
  final String movieName;
  final String id;
  final String poster;
  final dynamic vote;
  final String release;
  final bool favOrWatched;

  const MovieLabel(
      {Key key,
      this.movieName,
      this.id,
      this.poster,
      this.vote,
      this.release,
      this.favOrWatched})
      : super(key: key);
  @override
  _MovieLabelState createState() => _MovieLabelState();
}

class _MovieLabelState extends State<MovieLabel> {
  WatchedProvider _watchedProvider = WatchedProvider();
  bool _isNotDeleting = true;

  @override
  Widget build(BuildContext context) {
    var nameColor = Colors.grey[200];
    var releaseColor = Colors.grey;
    // change the color according to the theme
    if (Theme.of(context).brightness == Brightness.light)
      nameColor = Colors.black54;

    String movieName = widget.movieName;
    movieName ??= "Movie Name";

    return _isNotDeleting
        ? Padding(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ViewMovie(
                          movieId: int.parse(widget.id),
                        )));
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.2,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[800], width: 2),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(
                        child: Image(
                          image: NetworkImage(
                              "https://image.tmdb.org/t/p/w500/${widget.poster}"),
                        ),
                      ),
                      Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Spacer(),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            movieName,
                                            style: TextStyle(
                                              fontSize: 22,
                                              color: nameColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            widget.release,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: releaseColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Visibility(
                                      visible: widget.favOrWatched,
                                      child: Expanded(
                                        flex: 1,
                                        child: GestureDetector(
                                          onTap: () async {
                                            setState(() {
                                              _isNotDeleting = false;
                                            });
                                            await delete(int.parse(widget.id),widget.movieName);
                                          },
                                          child: Row(
                                            // Delete Button
                                            children: <Widget>[
                                              Icon(
                                                Icons.swap_horiz,
                                                size: 20,
                                                color: Colors.grey,
                                              ),
                                              Icon(
                                                Icons.delete,
                                                size: 20,
                                                color: Colors.grey,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                RatingBar(
                                  initialRating: widget.vote / 2,
                                  direction: Axis.horizontal,
                                  ignoreGestures: true,
                                  itemCount: 5,
                                  itemPadding:
                                      EdgeInsets.symmetric(horizontal: 3.0),
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    size: 30,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (double value) {},
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                child: Center(
              child: CircularProgressIndicator(),
            )),
          );
  }

  /// this function use to delete watched movies from the watched list
  delete(int id,String movieName) async {
    _isNotDeleting = false;

    _watchedProvider.removeWatchedMovies(id);
    Scaffold.of(context).showSnackBar(new SnackBar(
        content: Text(
          "Movie $movieName. Successfully Removed",
          style: TextStyle(color: Colors.grey),
        ),
        backgroundColor: Colors.grey[850]));
    new Future.delayed(new Duration(seconds: 1), () {
      _isNotDeleting = true;
      return 0;
    });
  }
}
