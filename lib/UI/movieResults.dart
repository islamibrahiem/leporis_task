import 'package:flutter/material.dart';
import 'src.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:leporis_task/Models/movieAllData.dart';
import 'package:leporis_task/Models/movieDetails.dart';

class SecondPage extends StatefulWidget {
  String movieName;

  SecondPage({this.movieName});

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  int pageNumber;

  List<Results> movies;
  ScrollController controller;
  int totalPages;
  DataBody dataBodyParsed;

  @override
  void initState() {
    // TODO: implement initState
    movies = new List<Results>();
    controller = new ScrollController()..addListener(_scrollListener);
    pageNumber = 1;
    super.initState();
  }

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    super.dispose();
  }

  Future<DataBody> fetchListUser(String movieName) async {
    print('willget from page : $pageNumber');
    final response = await http.get(
        'https://api.themoviedb.org/3/search/movie?api_key=$key&query=$movieName&page=$pageNumber');

    if (response.statusCode == 200) {
      Map dataBody = json.decode(response.body);
      totalPages = dataBody["total_pages"];
      return DataBody.fromJson(dataBody);
    } else
      throw Exception('Failed to load Data');
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.blueAccent,
          title: new Text(
            "Result",
            style: new TextStyle(color: Colors.white, fontSize: 20.0),
          ),
        ),
        body: new Scrollbar(
          child: Center(
            child: FutureBuilder<DataBody>(
              future: fetchListUser(widget.movieName),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  dataBodyParsed = snapshot.data;

                  if (dataBodyParsed.totalResults == 0) {
                    // debugPrint('Film Name Not Found');

                    return new Center(
                      child: new Container(
                        child: new AlertDialog(
                          title: new Text(
                            'No Result',
                            style: new TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                          content: new Text(
                            'Movie name not found try again',
                            style: new TextStyle(),
                          ),
                          actions: <Widget>[
                            new FlatButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: new Text('ok'))
                          ],
                        ),
                      ),
                    );
                  } else {
                    movies.addAll(dataBodyParsed.results);
                    dataBodyParsed.results.clear();
                    // movies = dataBodyParsed.results;

                    return new Container(
                      child: new Center(
                        child: ListView.builder(
                            controller: controller,
                            shrinkWrap: true,
                            itemCount: movies.length,
                            itemBuilder: (BuildContext context, int index) {
                              return new Container(
                                padding: EdgeInsets.all(25.0),
                                child: new Container(
                                  child: ListTile(
                                    leading: new Image.network(
                                        'https://image.tmdb.org/t/p/w92${movies[index].posterPath}'),
                                    title: new Text(
                                      "${movies[index].title}",
                                      style: new TextStyle(
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    subtitle: new Text(
                                      '${movies[index].overview}',
                                      style: new TextStyle(
                                          fontSize: 10.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                    );
                  }
                } else if (snapshot.hasError) {
                  //return Text('${snapshot.error}');
                  return new CircularProgressIndicator();
                } else if (!snapshot.hasData) {
                  return new Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ));
  }

  void _scrollListener() {
    if (pageNumber < totalPages) {
      if (controller.position.extentAfter < 1) {
        setState(() {
          pageNumber++;
        });
      }
    }
  }
}
