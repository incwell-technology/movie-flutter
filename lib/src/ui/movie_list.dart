import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:the_movies1/src/ui/movie_all.dart';
import '../../translations.dart';
import '../models/item_model.dart';
import '../blocs/movies_bloc.dart';
import 'movie_detail.dart';

class MovieList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MovieListState();
  }
}

class MovieListState extends State<MovieList> {
  @override
  void initState() {
    super.initState();
    bloc.fetchAllNowPlayingMovies();
    bloc.fetchAllPopularMovies();
    bloc.fetchAllTopRatedMovies();
    bloc.fetchAllUpComingMovies();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Center(
          child:  Text(
            Translations.of(context).text('main_title'),
            style: TextStyle(
              color: Colors.red,
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 5.0),
            child: CircleAvatar(
              backgroundColor: Colors.green,
            ),
          )
        ],
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            //Now Playing Movies
            Container(
              margin: EdgeInsets.fromLTRB(20, 10.0, 20, 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    Translations.of(context).text('now_playing'),
                    style: TextStyle(
                      fontSize: 22.0
                    ),
                  ),
                  FlatButton(
                    color: Colors.transparent,
                    onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>AllMovie(
                     'now_playing'
                    ))),
                    child: Text(
                      Translations.of(context).text('show_all'),
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 18.0
                      ),
                    ),
                  ),
                ],
              ),
            ),
            StreamBuilder(
              stream: bloc.allNowPlayingMovies,
              builder: (context, AsyncSnapshot<ItemModel> snapshot) {
                if (snapshot.hasData) {
                  return buildNowPlayingList(snapshot);
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
            //Popular Movies
            Container(
              margin: EdgeInsets.fromLTRB(20, 10.0, 20, 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    Translations.of(context).text('popular_movies'),
                    style: TextStyle(
                      fontSize: 22.0
                    ),
                  ),
                  FlatButton(
                    color: Colors.transparent,
                    onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>AllMovie(
                      'popular'
                    ))),
                    child: Text(
                      Translations.of(context).text('show_all'),
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 18.0
                      ),
                    ),
                  ),
                ],
              ),
            ),
            StreamBuilder(
              stream: bloc.allPopularMovies,
              builder: (context, AsyncSnapshot<ItemModel> snapshot) {
                if (snapshot.hasData) {
                  return buildPopularList(snapshot);
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
            //Upcoming Movies
            Container(
              margin: EdgeInsets.fromLTRB(20, 10.0, 20, 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    Translations.of(context).text('coming_soon'),
                    style: TextStyle(
                      fontSize: 22.0
                    ),
                  ),
                  FlatButton(
                    color: Colors.transparent,
                    onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>AllMovie(
                      'upcoming'
                    ))),
                    child: Text(
                      Translations.of(context).text('show_all'),
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 18.0
                      ),
                    ),
                  ),
                ],
              ),
            ),
            StreamBuilder(
              stream: bloc.allUpComingMovies,
              builder: (context, AsyncSnapshot<ItemModel> snapshot) {
                if (snapshot.hasData) {
                  return buildUpComingList(snapshot);
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                return Center(child: CircularProgressIndicator());
              },
            ),

            //TopRated Movies
            Container(
              margin: EdgeInsets.fromLTRB(20, 10.0, 20, 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    Translations.of(context).text('top_rated'),
                    style: TextStyle(
                      fontSize: 22.0
                    ),
                  ),
                  FlatButton(
                    color: Colors.transparent,
                    onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>AllMovie(
                      'top_rated'
                    ))),
                    child: Text(
                      Translations.of(context).text('show_all'),
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 18.0
                      ),
                    ),
                  ),
                ],
              ),
            ),
            StreamBuilder(
              stream: bloc.allTopRatedMovies,
              builder: (context, AsyncSnapshot<ItemModel> snapshot) {
                if (snapshot.hasData) {
                  return buildTopRatedList(snapshot);
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildNowPlayingList(AsyncSnapshot<ItemModel> snapshot) {
    return Container(
      margin: EdgeInsets.only(left: 15.0,right: 15.0),
      height: 210.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: snapshot.data.results.length,
        itemBuilder: (context,index){
          return Center(
            child: Container(
              margin: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
              height: 200.0,
              width: 130.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                image: DecorationImage(
                  image: NetworkImage('https://image.tmdb.org/t/p/w185${snapshot.data.results[index].poster_path}'),
                )
              ),
              child: InkResponse(
                enableFeedback: true,
                onTap: ()=>openDetailPage(snapshot.data, index),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildPopularList(AsyncSnapshot<ItemModel> snapshot) {
    return Container(
      margin: EdgeInsets.only(left: 15.0,right: 15.0),
      height: 210.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: snapshot.data.results.length,
        itemBuilder: (context,index){
          return Center(
            child: Container(
              margin: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
              height: 200.0,
              width: 130.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                image: DecorationImage(
                  image: NetworkImage('https://image.tmdb.org/t/p/w185${snapshot.data.results[index].poster_path}'),
                )
              ),
              child: InkResponse(
                enableFeedback: true,
                onTap: ()=>openDetailPage(snapshot.data, index),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildUpComingList(AsyncSnapshot<ItemModel> snapshot) {
    return Container(
      margin: EdgeInsets.only(left: 15.0,right: 15.0),
      height: 210.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: snapshot.data.results.length,
        itemBuilder: (context,index){
          return Center(
            child: Container(
              margin: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
              height: 200.0,
              width: 130.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                image: DecorationImage(
                  image: NetworkImage('https://image.tmdb.org/t/p/w185${snapshot.data.results[index].poster_path}'),
                )
              ),
              child: InkResponse(
                enableFeedback: true,
                onTap: ()=>openDetailPage(snapshot.data, index),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildTopRatedList(AsyncSnapshot<ItemModel> snapshot) {
    return Container(
      margin: EdgeInsets.only(left: 15.0,right: 15.0),
      height: 210.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: snapshot.data.results.length,
        itemBuilder: (context,index){
          return Center(
            child: Container(
              margin: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
              height: 200.0,
              width: 130.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                image: DecorationImage(
                  image: NetworkImage('https://image.tmdb.org/t/p/w185${snapshot.data.results[index].poster_path}'),
                )
              ),
              child: InkResponse(
                enableFeedback: true,
                onTap: ()=>openDetailPage(snapshot.data, index),
              ),
            ),
          );
        },
      ),
    );
  }
  openDetailPage(ItemModel data, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return MovieDetail(
            title: data.results[index].title,
            frontPosterUrl:data.results[index].poster_path,
            backPosterUrl: data.results[index].backdrop_path,
            description: data.results[index].overview,
            releaseDate: data.results[index].release_date,
            voteAverage: data.results[index].vote_average.toString(),
            movieId: data.results[index].id,
        );
      }),
    );
  }
}