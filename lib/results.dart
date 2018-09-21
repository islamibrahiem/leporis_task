import 'package:flutter/material.dart';
import 'src.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SecondPage extends StatefulWidget {
  String movieName;

  SecondPage({this.movieName});

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  List dataLength;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.blueAccent,
        title: new Text(
          "Result",
          style: new TextStyle(color: Colors.white, fontSize: 20.0),
        ),
      ),
      body: new FutureBuilder(
        future: getMovie(widget.movieName),
        builder: (BuildContext context, AsyncSnapshot movie) {
          Map data = movie.data;

          if (movie.hasError) {
            print(movie.error);
            return Text('Failed to get response from the server',
                style: TextStyle(color: Colors.red, fontSize: 30.0));
          } else if (movie.hasData) {
            if (data["total_results"] == 0) {
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
              return new Container(
                child: new Center(
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: dataLength.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          leading: new Image.network(
                              'https://image.tmdb.org/t/p/w92${data["results"][index]["poster_path"]}'),
                          title: new Text(
                            "${data["results"][index]["title"]}",
                            style: new TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          subtitle: new Text(
                            '${data["results"][index]["overview"]}',
                            style: new TextStyle(
                                fontSize: 10.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.red),
                          ),
                        );
                      }),
                ),
              );
            }
          } else if (!movie.hasData) {
            return new Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Future<Map> getMovie(String movieName) async {
    String url =
        'https://api.themoviedb.org/3/search/movie?api_key=$key&query=$movieName&';
    http.Response response = await http.get(url);
    setState(() {
      var resBody = json.decode(response.body);
      dataLength = resBody["results"];
    });
    return json.decode(response.body);
  }
}
