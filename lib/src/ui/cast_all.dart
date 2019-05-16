import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:the_movies1/src/models/cast_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'cast_detail.dart';

class AllCast extends StatefulWidget {
  
  final int movieId;
  AllCast(this.movieId);
  @override
  _AllCastState createState() => _AllCastState();
}

class _AllCastState extends State<AllCast> {
 List fetchAll=[];

  @override
  void initState() {
    super.initState();
    fetchAllCast();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cast & Crew'),
      ),
      body: Container(
        child: GridView.builder(
        itemCount: fetchAll.length,
        gridDelegate:
            new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          return Stack(
            children: <Widget>[
               Container(
                margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  image: DecorationImage(
                    image: (fetchAll[index].profilePath==null)?AssetImage('images/image.jpg') : 
                    NetworkImage(
                    'https://image.tmdb.org/t/p/w138_and_h175_face${fetchAll[index].profilePath}',
                  ),
                  fit: BoxFit.cover,
                  )
                ),
                child: InkResponse(
                  enableFeedback: true,
                  onTap: ()=>openDetailCast(index),
                ),
              ),
              Positioned(
                child: Center(
                  child: Container(
                    margin: EdgeInsets.only(top:150.0),
                    color: Colors.black,
                    child: Text(
                  '${fetchAll[index].name}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
                  )
                )
              )
            ],
          );
        })
      ),
    );
  }

  fetch(int movieId) async{
    var url='https://api.themoviedb.org/3/movie/$movieId/casts?api_key=cfd028b6529b7ced061b1c3edbf1276b';
    var castModel;
    // Await the http get response, then decode the json-formatted responce.
    var response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        Map jsonResponse = jsonDecode(response.body);
        castModel = new ActorsModel.fromJson(jsonResponse);
        for(int i=0;i<castModel.cast.length;i++){
          print('${castModel.cast[i].name}');
          fetchAll.add(castModel.cast[i]);
        }        
      });
    } else {
      print("Request failed with status: ${response.statusCode}.");
    }
    return castModel;
  }

  fetchAllCast(){
    fetch(widget.movieId);
  }

  openDetailCast(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return CastDetail(
            name:fetchAll[index].name,
            castId:fetchAll[index].castId,
            gender:fetchAll[index].gender,
            character:fetchAll[index].character,
            profilePath:fetchAll[index].profilePath,
            id:fetchAll[index].id,
        );
      }),
    );
  }
}