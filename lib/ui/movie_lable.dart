import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:popcorn/ui/view_movie.dart';

class MovieLabel extends StatefulWidget {
  final String movieName;
  final String id;
  final String poster;
  final dynamic vote;
  final String release;
  final bool favOrWatched;
  final Function(String) delete;

  const MovieLabel(
      {Key key,
      this.movieName,
      this.id,
      this.poster,
      this.vote,
      this.release,
      this.favOrWatched,
      this.delete})
      : super(key: key);
  @override
  _MovieLabelState createState() => _MovieLabelState();
}

class _MovieLabelState extends State<MovieLabel> {
//  deleteLable(){
//    widget.delete =
//  }

  @override
  Widget build(BuildContext context) {
    var nameColor = Colors.grey[200];
    var releaseColor = Colors.grey;
    if (Theme.of(context).brightness == Brightness.light)
      nameColor = Colors.black54;

    String movieName = widget.movieName;
    movieName ??= "Movie Name";

    return Padding(
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
//                        Expanded(
//                          child:
                          Spacer(),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 4,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      movieName,
                                      style: TextStyle(
                                        fontSize: 22,
                                        color: nameColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
//                        ),Expanded(
//                          child:
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
                                    onTap: () {
                                      widget.delete(widget.id);
                                      setState(() {});
//                                  _watchedProvider.addToWatchedMovies(widget.movieName, widget.id, widget.poster, widget.vote, widget.release);
                                    },
                                    child: Row(
                                      // Replace with a Row for horizontal icon + text
                                      children: <Widget>[
                                        Icon(
                                          Icons.delete,
                                          size: 40,
                                          color: Colors.grey[200],
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
                            itemPadding: EdgeInsets.symmetric(horizontal: 3.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (double value) {},
//                      onRatingUpdate: (rating) {
//                        print(rating);
//                      },
                          ),

//                        Padding(
//                          padding: const EdgeInsets.all(8.0),
//                          child: Row(
//                            crossAxisAlignment: CrossAxisAlignment.end,
//                            children: <Widget>[
//                              Expanded(
//
//                                child: GestureDetector(
//                                  onTap: (){
//                                    _watchedProvider.addToWatchedMovies(movieName, widget.id, widget.poster);
//                                  },
//                                  child: Container(
//                                    decoration: BoxDecoration(
//                                        color: Colors.blue[800],
//                                        borderRadius: BorderRadius.all(Radius.circular(5))
//                                    ),
//
//                                    margin: new EdgeInsets.fromLTRB(0, 0, 8, 0),
//                                    child: Padding(
//                                      padding: const EdgeInsets.fromLTRB(5,2,0,5),
//                                      child: Row( // Replace with a Row for horizontal icon + text
//                                        children: <Widget>[
//                                          Icon(Icons.visibility,
//                                            color: Colors.grey[200],),
//                                          Text(" Add to \n Watched List",
//
//                                            style: TextStyle(
//                                                color: Colors.grey[300],
//                                                fontWeight: FontWeight.bold
//                                            ),)
//                                        ],
//                                      ),
//                                    ),
//                                  ),
//                                ),
//                              ),
//                              Expanded(
//
//                                child: GestureDetector(
//                                  onTap: (){
//                                    _addOrRemoveFavourite();
//                                  },
//                                  child: Container(
//                                    decoration: BoxDecoration(
//                                        color: Colors.orange,
//                                        borderRadius: BorderRadius.all(Radius.circular(5))
//                                    ),
//                                    child: Padding(
//                                      padding: const EdgeInsets.fromLTRB(5, 2, 2, 5),
//                                      child: Row( // Replace with a Row for horizontal icon + text
//                                        children: <Widget>[
//                                          Icon(Icons.star,
//                                            color: Colors.black87,),
//                                          Text(" Add to \n favorites",
//
//                                            style: TextStyle(
//                                                color: Colors.black87,
//                                                letterSpacing: 1.0,
//                                                fontWeight: FontWeight.bold
//                                            ),)
//                                        ],
//                                      ),
//                                    ),
//                                  ),
//                                ),
//                              )
//                            ],
//                          ),
//                        ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
