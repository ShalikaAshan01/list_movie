import 'package:flutter/material.dart';
import 'package:popcorn/models/movie_model.dart';

class ViewMovie extends StatefulWidget {
  final int movieId;
  final MovieModel movieModel;

  const ViewMovie({Key key,@required this.movieId, this.movieModel}) : super(key: key);
  @override
  _ViewMovieState createState() => _ViewMovieState();
}

class _ViewMovieState extends State<ViewMovie> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
