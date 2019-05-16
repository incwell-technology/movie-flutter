import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:the_movies1/src/models/cast_model.dart';
import 'package:the_movies1/src/models/cast_model_detail.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class CastDetail extends StatefulWidget {
  final int id;
  final String name;
  final int castId;
  final int gender;
  final String character;
  final String profilePath;

  CastDetail({
    this.id,
    this.name,
    this.castId,
    this.gender,
    this.character,
    this.profilePath,
  });

  @override
  State<StatefulWidget> createState() {
    return CastDetailState(
      id:id,
      name:name,
      castId:castId,
      gender:gender,
      character:character,
      profilePath:profilePath
    );
  }
}

class CastDetailState extends State<CastDetail> {
  final int id;
  final String name;
  final int castId;
  final int gender;
  final String character;
  final String profilePath;


  CastDetailState({
    this.id,
    this.name,
    this.castId,
    this.gender,
    this.character,
    this.profilePath,

  });

  ActorsModel actors;
  List personalInfo=[];

  @override
  void initState() {
    super.initState();
    fetchPersonal(id);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$name'),
      ),
     body: SingleChildScrollView(
       child: Container(
       margin: EdgeInsets.only(top:10),
       height: MediaQuery.of(context).size.height,
       width: MediaQuery.of(context).size.width,
       child: Stack(
         children: <Widget>[
           Container(
             height: MediaQuery.of(context).size.height,
             width: MediaQuery.of(context).size.width,
             margin: EdgeInsets.fromLTRB(10, 60, 10, 10),
             decoration: BoxDecoration(
               borderRadius: BorderRadius.circular(10),
               gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment(0.8, 0.0), // 10% of the width, so there are ten blinds.
                  colors: [const Color(0xFF0f0c29), const Color(0xFF302b63), const Color(0xFF24243e)], // whitish to gray
                  tileMode: TileMode.repeated, // repeats the gradient over the canvas
                ),
             ),
             child: Column(
               children: <Widget>[
                 SizedBox(height: 90),
                 Text(
                   '$name',
                   style: TextStyle(
                     fontSize: 25.0,
                     fontStyle: FontStyle.italic,
                     color: Colors.white
                   ),
                 ),
                 SizedBox(height: 15.0,),
                 Text(
                   'Biography',
                   style: TextStyle(
                     fontSize: 25.0,
                     color: Colors.white
                   ),
                 ),
                 Container(
                   margin: EdgeInsets.only(left: 5.0,right: 5.0),
                   child: Card(
                   color: Colors.white,
                   elevation: 6.0,
                   child: Container(
                   height: 150,
                   child: ListView.builder(
                    itemCount: personalInfo.length,
                    itemBuilder: (context,index){
                      return ListTile(
                        title:  Text(
                          '${personalInfo[index].biography}',
                          style: TextStyle(
                            fontSize: 22.0
                          ),
                        ),
                      );
                    },
                  ),
                 ),
                 ),
                 ),
                 SizedBox(height: 15.0,),
                 Text(
                   'Personal Info',
                   style: TextStyle(
                     fontSize: 25.0,
                     color: Colors.white
                   ),
                 ),
                 Container(
                   margin: EdgeInsets.only(left: 5.0,right: 5.0),
                   child: Card(
                   color: Colors.white,
                   elevation: 6.0,
                   child: Container(
                   height: 230,
                   child: ListView.builder(
                    itemCount: personalInfo.length,
                    itemBuilder: (context,index){
                      return Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.all(10.0),
                            child: Row(
                              children: <Widget>[
                                Text('Known For :',style: TextStyle(fontSize: 22.0,fontWeight: FontWeight.bold),),
                                Text(' ${personalInfo[index].knownForDepartment}',style: TextStyle(fontSize: 22.0),)
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(10.0),
                            child: Row(
                              children: <Widget>[
                                Text('Birthday :',style: TextStyle(fontSize: 22.0,fontWeight: FontWeight.bold),),
                                Text(' ${personalInfo[index].birthday}',style: TextStyle(fontSize: 22.0),)
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(10.0),
                            child: Row(
                              children: <Widget>[
                                Text('Popularity:',style: TextStyle(fontSize: 22.0,fontWeight: FontWeight.bold),),
                                Text(' ${personalInfo[index].popularity}',style: TextStyle(fontSize: 22.0),)
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(10.0),
                            child: Row(
                              children: <Widget>[
                                Text('Place of Birth :',style: TextStyle(fontSize: 22.0,fontWeight: FontWeight.bold),),
                                Expanded(
                                  child: Text(' ${personalInfo[index].placeOfBirth}',style: TextStyle(fontSize: 22.0),),
                                )
                              ],
                            ),
                          )
                        ],
                      );
                    },
                  ),
                 ),
                 ),
                 ),
                
               ],
             ),
           ),
           Positioned(
             left: MediaQuery.of(context).size.width/3.25,
             child: Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                image: DecorationImage(
                  image: NetworkImage('https://image.tmdb.org/t/p/w138_and_h175_face$profilePath'),
                  fit: BoxFit.cover
                ),
              ),
            )
           )
         ],
       ),
     ),
     )
    );
  }
  
  fetchPersonal(int ci) async{
    AllCastDetail casts;
    var url='https://api.themoviedb.org/3/person/$ci?api_key=cfd028b6529b7ced061b1c3edbf1276b';
    var response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        var decoded = json.decode(response.body);
        casts = AllCastDetail.fromJson(decoded);
        personalInfo.add(casts);
        print(personalInfo);     
      });
    } else {
      print("Request failed with status: ${response.statusCode}.");
    }
    return casts;
  }
}