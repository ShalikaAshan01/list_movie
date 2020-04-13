import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:popcorn/controllers/auth_provider.dart';
import 'package:popcorn/models/cast_model.dart';
import 'package:popcorn/models/firebase_movie_model.dart';
import 'package:popcorn/models/movie_model.dart';
import 'package:popcorn/models/popular_movie_model.dart';

const apiKey = "936a7962c81c6aa84566e2026c8616f4";

/// This entry point call the tMDB api and fetch movies from the api
/// https://api.themoviedb.org/ or movie stores in firestore
class MovieProvider {
  final _dio = Dio();

  /// Provides a method for get popular movies from the api
  Future<PopularMovieResult> fetchPopularMovies(int pageNo) async {
    final url =
        "https://api.themoviedb.org/3/movie/popular?api_key=$apiKey&language=en-US&page=$pageNo";
    final response = await _dio.get(url);
    final data = response.data;
    final movieResult = PopularMovieResult.fromJson(data);
    return movieResult;
  }

  /// Provides a method for get specific movie information from the tMDB API.
  Future<MovieModel> getModvie(int id) async {
    final url =
        "https://api.themoviedb.org/3/movie/$id?api_key=$apiKey&language=en-US";
    final response = await _dio.get(url);
    final movie = MovieModel.fromJson(response.data);
    return movie;
  }

  /// Get a all cast list for the specific movie
  Future<List<CastModel>> getCastList(int id) async {
    final url =
        "https://api.themoviedb.org/3/movie/$id/credits?api_key=$apiKey";
    final response = await _dio.get(url);
    List<CastModel> list = (response.data["cast"] as List)
        .map((i) => CastModel.fromJson(i))
        .toList();
    return list;
  }

  /// Provides a method for get movie recommendations for the specific movie
  Future<PopularMovieResult> getMovieRecommendations(int id,
      {int pageNo = 1}) async {
    final url =
        "https://api.themoviedb.org/3/movie/$id/recommendations?api_key=$apiKey&language=en-US&page=$pageNo";
    final response = await _dio.get(url);
    final data = response.data;
    final movieResult = PopularMovieResult.fromJson(data);
    return movieResult;
  }

  /// Provides a method for access specific movie from the firestore. This movie
  /// is belong to the logged user.
  Future<FirebaseMovieModel> fetchMovieFromFirebase(int movieId) async {
    AuthProvider _auth = AuthProvider();
    Firestore _firestore = Firestore.instance;
    final user = await _auth.getUser();
    final list = await _firestore
        .collection('user')
        .document(user.uid)
        .collection("Movies")
        .where('movieId', isEqualTo: movieId)
        .getDocuments();
    if (list.documents.length == 0) return null;
    FirebaseMovieModel movie =
        FirebaseMovieModel.fromMap(list.documents.first.data);
    return movie;
  }
}
