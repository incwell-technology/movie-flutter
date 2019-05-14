import 'dart:async';
import 'movie_api_provider.dart';
import '../models/item_model.dart';

class Repository {
  final moviesApiProvider = MovieApiProvider();

  Future<ItemModel> fetchAllPopularMovies() => moviesApiProvider.fetchMovieListPopular();

  Future<ItemModel> fetchAllNowPlayingMovies() => moviesApiProvider.fetchMovieListNowPlaying();

  Future<ItemModel> fetchAllTopRatedMovies() => moviesApiProvider.fetchMovieListTopRated();

  Future<ItemModel> fetchAllUpComingMovies() => moviesApiProvider.fetchMovieListUpcoming();

  

}