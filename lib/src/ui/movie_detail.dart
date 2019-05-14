import 'package:flutter/material.dart';
import 'package:the_movies1/src/models/item_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../translations.dart';

class MovieDetail extends StatefulWidget {
  final frontPosterUrl;
  final backPosterUrl;
  final description;
  final releaseDate;
  final String title;
  final String voteAverage;
  final int movieId;

  MovieDetail({
    this.title,
    this.frontPosterUrl,
    this.backPosterUrl,
    this.description,
    this.releaseDate,
    this.voteAverage,
    this.movieId,
  });

  @override
  State<StatefulWidget> createState() {
    return MovieDetailState(
      title: title,
      frontPosterUrl:frontPosterUrl,
      backPosterUrl: backPosterUrl,
      description: description,
      releaseDate: releaseDate,
      voteAverage: voteAverage,
      movieId: movieId,
    );
  }
}

class MovieDetailState extends State<MovieDetail> {
  final frontPosterUrl;
  final backPosterUrl;
  final description;
  final releaseDate;
  final String title;
  final String voteAverage;
  final int movieId;


  MovieDetailState({
    this.title,
    this.frontPosterUrl,
    this.backPosterUrl,
    this.description,
    this.releaseDate,
    this.voteAverage,
    this.movieId,
  });

  ItemModel movie;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: Colors.white,
              expandedHeight: 300.0,
              floating: false,
              pinned: true,
              elevation: 0.0,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Container(
                              height: 200,
                              width: MediaQuery.of(context).size.width,
                              child: Image(
                                image: NetworkImage('https://image.tmdb.org/t/p/w500$backPosterUrl'),
                                fit: BoxFit.cover,
                              ),
                            ),
                            Center(
                              child: Container(
                                margin: EdgeInsets.only(top: 70.0),
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      title,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 21.0),
                                    ),
                                  ],
                                )
                              )
                            )
                          ],
                        ),
                        Container(
                          height: 90.0,
                          color: Colors.grey[200],
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(right: 30.0, top: 20.0),
                                child: Column(
                                  children: <Widget>[
                                    Icon(Icons.watch_later),
                                    Text('Watchlist')
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 30.0, top: 20.0),
                                child: Column(
                                  children: <Widget>[
                                    Icon(Icons.favorite),
                                    Text('Favorite')
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 30.0, top: 20.0),
                                child: Column(
                                  children: <Widget>[
                                    Icon(Icons.share),
                                    Text('Share')
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height / 10,
                      left: 20.0,
                      child: Card(
                        elevation: 6.0,
                        color: Colors.transparent,
                        child: Container(
                          height: 200.0,
                          width: 130.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              image: DecorationImage(
                                image: NetworkImage(
                                  'https://image.tmdb.org/t/p/w185_and_h278_bestv2$frontPosterUrl'
                                )
                              )
                          ),
                        ),
                      )
                    )
                  ],
                )
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top:5.0,left: 20.0),
                          child: Text(
                            Translations.of(context).text('overview'),
                            style: TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      
                        Container(
                          margin: EdgeInsets.only(top:8.0,left: 20.0),
                          child: Text(
                            description,
                            style: TextStyle(
                              fontSize: 20.0
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 8.0,left: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                Translations.of(context).text('cast'),
                                style: TextStyle(
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              FlatButton(
                                color: Colors.transparent,
                                onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>MovieDetail())),
                                child: Text(
                                  Translations.of(context).text('view_all'),
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 18.0
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        Container(
                          margin: EdgeInsets.only(top: 8.0),
                          height: 100.0,
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 8.0,left: 20.0),
                          child: Text(
                            Translations.of(context).text('recommendation'),
                            style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 8.0),
                          child:StreamBuilder(
                            stream: fetchData(movieId),
                            builder: (context,snapshot) {
                              if (snapshot.hasData) {
                                return buildRecommendedList(snapshot);
                              } else if (snapshot.hasError) {
                                return Text(snapshot.error.toString());
                              }
                              return Center(child: CircularProgressIndicator());
                            },
                          ),
                        ),
                        
                        Container(margin: EdgeInsets.only(top: 8.0,
                            bottom: 8.0)),
                        
                      ],
                    ),
                  ),
                ]
              ),
            )
          ],
        )
      ),
    );
  }

  Stream<ItemModel>fetchData(int movieId) async*{
    ItemModel movie;
    var url='https://api.themoviedb.org/3/movie/$movieId/recommendations?api_key=cfd028b6529b7ced061b1c3edbf1276b';
    var response = await http.get(url);
    var decoded = json.decode(response.body);
    movie = ItemModel.fromJson(decoded);
    // print(movie.results);
    yield movie;
  }

  Widget buildRecommendedList(AsyncSnapshot<ItemModel> snapshot) {
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