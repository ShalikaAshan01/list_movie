import 'package:flutter/material.dart';
import 'package:popcorn/controllers/favourite_provider.dart';

class MovieLabel extends StatefulWidget {
  final String movieName;
  final String id;
  final String poster;
  const MovieLabel({Key key, this.movieName, this.id, this.poster}) : super(key: key);
  @override
  _MovieLabelState createState() => _MovieLabelState();
}

class _MovieLabelState extends State<MovieLabel> {
  @override
  Widget build(BuildContext context) {
    var nameColor = Colors.grey[200];
    if(Theme.of(context).brightness == Brightness.light)
      nameColor = Colors.black54;

    String movieName = widget.movieName;
    movieName ??= "Movie Name";

    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
      child: Container(
        //TODO: overflow from here
        height: MediaQuery.of(context).size.height * 0.2,
        decoration: BoxDecoration(
          border: Border.all(
              color: Colors.grey[800],
              width: 2
          ),
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
                  image: NetworkImage("https://image.tmdb.org/t/p/w500/${widget.poster}"),
                ),),
              Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8.0,0,8,0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Center(
                            child: Text(movieName,
                              style: TextStyle(
                                fontSize:20,
                                color: nameColor,
                                fontWeight: FontWeight.bold,
                              ),),
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Expanded(

                                child: GestureDetector(
                                  onTap: (){
                                    print("sad");
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.blue[800],
                                        borderRadius: BorderRadius.all(Radius.circular(5))
                                    ),

                                    margin: new EdgeInsets.fromLTRB(0, 0, 8, 0),
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(5,2,0,5),
                                      child: Row( // Replace with a Row for horizontal icon + text
                                        children: <Widget>[
                                          Icon(Icons.visibility,
                                            color: Colors.grey[200],),
                                          Text(" Add to \n Watched List",

                                            style: TextStyle(
                                                color: Colors.grey[300],
                                                fontWeight: FontWeight.bold
                                            ),)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(

                                child: GestureDetector(
                                  onTap: (){
                                    _addOrRemoveFavourite();
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.orange,
                                        borderRadius: BorderRadius.all(Radius.circular(5))
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(5, 2, 2, 5),
                                      child: Row( // Replace with a Row for horizontal icon + text
                                        children: <Widget>[
                                          Icon(Icons.star,
                                            color: Colors.black87,),
                                          Text(" Add to \n favorites",

                                            style: TextStyle(
                                                color: Colors.black87,
                                                letterSpacing: 1.0,
                                                fontWeight: FontWeight.bold
                                            ),)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
              )
            ],
          ),
        ),
      ),
    );
  }

  void _addOrRemoveFavourite() {
    FavouriteProvider favouriteProvider = FavouriteProvider();
    favouriteProvider.addOrRemoveFavourite(int.parse(widget.id));
  }
}