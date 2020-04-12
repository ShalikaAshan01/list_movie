import 'package:flutter/cupertino.dart';

class PopularMovieResult{
  int page;
  int totalResults;
  int totalPages;
  List<PopularMovieInformation> movieInformations;

  PopularMovieResult({
     @required this.page,
  @required this.totalResults,
  @required this.totalPages,
     this.movieInformations,
  });

  factory PopularMovieResult.fromJson(Map<String, dynamic> json) {
    List<PopularMovieInformation> list;
    if (json['results'] != null) {
      list = List<PopularMovieInformation>();
      json['results'].forEach((v) {
        list.add(PopularMovieInformation.fromJson(v));
      });
    }
    return PopularMovieResult(
      page: json["page"],
      totalResults: json["total_results"],
      totalPages: json["total_pages"],
      movieInformations: list
    );
  }

}

class PopularMovieInformation {
  dynamic popularity;
  dynamic voteCount;
  bool video;
  String posterPath;
  dynamic id;
  bool adult;
  String backdropPath;
  String originalLanguage;
  String originalTitle;
  List<int> genreIds;
  String title;
  dynamic voteAverage;
  String overview;
  String releaseDate;

  PopularMovieInformation(
      {this.popularity,
        this.voteCount,
        this.video,
        this.posterPath,
        this.id,
        this.adult,
        this.backdropPath,
        this.originalLanguage,
        this.originalTitle,
        this.genreIds,
        this.title,
        this.voteAverage,
        this.overview,
        this.releaseDate});

  PopularMovieInformation.fromJson(Map<String, dynamic> json) {
    popularity = json['popularity'];
    voteCount = json['vote_count'];
    video = json['video'];
    posterPath = json['poster_path'];
    id = json['id'];
    adult = json['adult'];
    backdropPath = json['backdrop_path'];
    originalLanguage = json['original_language'];
    originalTitle = json['original_title'];
    genreIds = json['genre_ids'].cast<int>();
    title = json['title'];
    voteAverage = json['vote_average'];
    overview = json['overview'];
    releaseDate = json['release_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['popularity'] = this.popularity;
    data['vote_count'] = this.voteCount;
    data['video'] = this.video;
    data['poster_path'] = this.posterPath;
    data['id'] = this.id;
    data['adult'] = this.adult;
    data['backdrop_path'] = this.backdropPath;
    data['original_language'] = this.originalLanguage;
    data['original_title'] = this.originalTitle;
    data['genre_ids'] = this.genreIds;
    data['title'] = this.title;
    data['vote_average'] = this.voteAverage;
    data['overview'] = this.overview;
    data['release_date'] = this.releaseDate;
    return data;
  }
}
