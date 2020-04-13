import 'package:flutter/material.dart';

/// This model class can get movie information from the firestore
class FirebaseMovieModel {
  String title;
  int movieId;
  String poster;
  bool favourite;
  bool watched;
  double vote;
  String release;
  String runtime;
  List<dynamic> genres;

  FirebaseMovieModel({
    @required this.title,
    @required this.movieId,
    @required this.poster,
    @required this.favourite,
    @required this.watched,
    @required this.vote,
    @required this.release,
    @required this.genres,
    @required this.runtime,
  });

  /// This method will cast dart object to json object
  Map<String, dynamic> toMap() {
    return {
      'title': this.title,
      'movieId': this.movieId,
      'poster': this.poster,
      'favourite': this.favourite,
      'watched': this.watched,
      'vote': this.vote,
      'release': this.release,
      'genres': this.genres,
      'runtime': this.runtime,
    };
  }

  /// This method will cast json object to dart object
  factory FirebaseMovieModel.fromMap(Map<String, dynamic> map) {
    return FirebaseMovieModel(
      title: map['title'] as String,
      movieId: map['movieId'] as int,
      poster: map['poster'] as String,
      favourite: map['favourite'] as bool,
      watched: map['watched'] as bool,
      vote: map['vote'] as double,
      genres: map['genres'] as List,
      runtime: map['runtime'] as String,
      release: map['release'] as String,
    );
  }
}
