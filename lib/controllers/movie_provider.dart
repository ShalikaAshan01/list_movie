import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:popcorn/models/movie_model.dart';
import 'package:popcorn/models/popular_movie_model.dart';

const apiKey = "936a7962c81c6aa84566e2026c8616f4";
class MovieProvider{
  final _dio = Dio();

  ///Get popular movies
  Future<void> fetchPopularMovies(int pageNo)async{
    final url = "https://api.themoviedb.org/3/movie/popular?api_key=$apiKey&language=en-US&page=$pageNo";
    final response = await _dio.get(url);
    final data = response.data;
    final movieResult = PopularMovieResult.fromJson(data);
    return movieResult;
  }

  Future<MovieModel> getModvie(int id)async{
    final url = "https://api.themoviedb.org/3/movie/$id?api_key=$apiKey&language=en-US";
    final response = await _dio.get(url);
    final movie = MovieModel.fromJson(response.data);
    return movie;
  }
}