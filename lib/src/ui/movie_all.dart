import 'package:flutter/material.dart';
import 'package:the_movies1/src/models/item_model_show_all.dart';
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
 List fetchAll=[];
 int i=1;
 ScrollController _scrollController=ScrollController();

  @override
  void initState() {
    super.initState();
    fetchAllMovie();
    _scrollController.addListener((){
      if(_scrollController.position.pixels==_scrollController.position.maxScrollExtent){
        i++;
        fetchAllMovie();
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
        title: Text('${widget.category}'),
      ),
      body: Container(
        child: GridView.builder(
          controller: _scrollController,
        itemCount: fetchAll.length,
        gridDelegate:
            new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              image: DecorationImage(
                image: NetworkImage(
                'https://image.tmdb.org/t/p/w185${fetchAll[index].posterPath}',
              ),
              fit: BoxFit.cover,
              )
            ),
            child: InkResponse(
              enableFeedback: true,
              onTap: ()=>openDetailPage(index),
            ),
          );
        })
      ),
    );
  }

  fetch(int page, String category) async{
    var url='https://api.themoviedb.org/3/movie/$category?api_key=cfd028b6529b7ced061b1c3edbf1276b&page=$page';
    var itemModel;
    // Await the http get response, then decode the json-formatted responce.
    var response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        Map jsonResponse = jsonDecode(response.body);
        itemModel = new ItemModel.fromJson(jsonResponse);
        for(int i=1;i<itemModel.results.length;i++){
          print('${itemModel.results[i].title}');
          fetchAll.add(itemModel.results[i]);
        }        
      });
    } else {
      print("Request failed with status: ${response.statusCode}.");
    }
    return itemModel;
  }

  fetchAllMovie(){
    fetch(i,widget.category);
  }

    openDetailPage(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return MovieDetail(
            title: fetchAll[index].title,
            frontPosterUrl:fetchAll[index].posterPath,
            backPosterUrl: fetchAll[index].backdropPath,
            description: fetchAll[index].overview,
            releaseDate: fetchAll[index].releaseDate,
            voteAverage: fetchAll[index].voteAverage.toString(),
            movieId: fetchAll[index].id,
        );
      }),
    );
  }
}