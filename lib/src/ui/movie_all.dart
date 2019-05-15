import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:the_movies1/src/models/item_model.dart';

import 'movie_detail.dart';

class AllMovie extends StatefulWidget {
  final String category;

  AllMovie(this.category);

  @override
  _AllMovieState createState() => _AllMovieState();
}

class _AllMovieState extends State<AllMovie> {
  List<Result> movies = List();
  int page = 0;

  final ValueNotifier<int> i = ValueNotifier<int>(1);
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchMovies(widget.category);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        fetchMovies(widget.category);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
      ),
      body: buildAllList(),
    );
  }

  fetchMovies(String category) async {
    var newPage = page + 1;
    var url =
        'https://api.themoviedb.org/3/movie/$category?api_key=cfd028b6529b7ced061b1c3edbf1276b&page=$newPage';
    var response = await http.get(url);
    var decoded = json.decode(response.body);
    setState(() {
      ItemModel model = ItemModel.fromJson(decoded);
      movies.addAll(model.results);
      page = model.page;
    });
  }

  Widget buildAllList() {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return orientation == Orientation.landscape
        ? GridView.builder(
            controller: _scrollController,
            itemCount: movies.length,
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: MediaQuery.of(context).size.height / 1000,
            ),
            itemBuilder: (BuildContext context, int index) {
              return Container(
                height: 100,
                margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    image: DecorationImage(
                        image: NetworkImage(
                          'https://image.tmdb.org/t/p/w185${movies[index].poster_path}',
                        ),
                        fit: BoxFit.fill)),
                child: InkResponse(
                  enableFeedback: true,
                  onTap: () => openDetailPage(index),
                ),
              );
            })
        : GridView.builder(
            controller: _scrollController,
            itemCount: movies.length,
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: MediaQuery.of(context).size.height / 1000,
            ),
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    image: DecorationImage(
                        image: NetworkImage(
                          'https://image.tmdb.org/t/p/w185${movies[index].poster_path}',
                        ),
                        fit: BoxFit.fill)),
                child: InkResponse(
                  enableFeedback: true,
                  onTap: () => openDetailPage(index),
                ),
              );
            });
  }

  openDetailPage(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return MovieDetail(
          title: movies[index].title,
          frontPosterUrl: movies[index].poster_path,
          backPosterUrl: movies[index].backdrop_path,
          description: movies[index].overview,
          releaseDate: movies[index].release_date,
          voteAverage: movies[index].vote_average.toString(),
          movieId: movies[index].id,
        );
      }),
    );
  }
}
