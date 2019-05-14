import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:the_movies1/src/models/item_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'movie_detail.dart';

class AllMovie extends StatefulWidget {
  final String category;
  AllMovie(this.category);

  @override
  _AllMovieState createState() => _AllMovieState();
}

class _AllMovieState extends State<AllMovie> {
  final ValueNotifier<int> i= ValueNotifier<int>(1);
  ScrollController _scrollController=ScrollController();

  

  @override
  void initState() {
    super.initState();
    int j=i.value;

    fetchData(j, widget.category);
    _scrollController.addListener((){
      if(_scrollController.position.pixels==_scrollController.position.maxScrollExtent){
        i.value+=1;
        fetchData(i.value,widget.category);
        // print(i.value);
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
      body: Container(
        margin: EdgeInsets.only(top: 8.0),
        child:ValueListenableBuilder(
          builder: (context,index,child){
            print(index);
            return StreamBuilder(
              stream: fetchData(index,widget.category),
              builder: (context,snapshot) {
                if (snapshot.hasData) {
                  // print(snapshot);
                  return buildAllList(snapshot);
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                return Center(child: CircularProgressIndicator());
              },
            );
          },
          valueListenable: i,
        )
      ),
    );
  }
 
  Stream<ItemModel>fetchData(int page,String category) async*{
    ItemModel movie;
    var url='https://api.themoviedb.org/3/movie/$category?api_key=cfd028b6529b7ced061b1c3edbf1276b&page=$page';
    var response = await http.get(url);
    var decoded = json.decode(response.body);
    movie = ItemModel.fromJson(decoded);
    yield movie;
  }

  
  Widget buildAllList(AsyncSnapshot<ItemModel> snapshot) {
    return GridView.builder(
      controller: _scrollController,
      itemCount: snapshot.data.results.length,
      gridDelegate:
      new SliverGridDelegateWithFixedCrossAxisCount(
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
                'https://image.tmdb.org/t/p/w185${snapshot.data.results[index].poster_path}',
              ),
              fit: BoxFit.fill
            )
          ),
          child: InkResponse(
            enableFeedback: true,
            onTap: () => openDetailPage(snapshot.data, index),
          ),
        );
      }
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