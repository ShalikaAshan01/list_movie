import 'package:flutter/material.dart';
import 'package:popcorn/models/movie_model.dart';

class ViewMovie extends StatefulWidget {
  final int movieId;
  final MovieModel movie;

  const ViewMovie({Key key,this.movieId, this.movie}) : assert(movie != null || movieId !=null);
  @override
  _ViewMovieState createState() => _ViewMovieState();
}

class _ViewMovieState extends State<ViewMovie> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("hi"),
      ),
    );
  }
}
