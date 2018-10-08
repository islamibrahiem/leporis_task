import 'package:flutter/material.dart';
import 'package:leporis_task/UI/movieResults.dart';

class FirstPage extends StatelessWidget {
  var _movieNameController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.blueAccent,
        title: new Text(
          "TMDB",
          style: new TextStyle(color: Colors.white, fontSize: 20.0),
        ),
      ),
      body: Material(
        color: Colors.white,
        child: Center(
          child: new ListView(
            children: <Widget>[
              Padding(padding: const EdgeInsets.all(30.0)),
              new Image.asset(
                'images/moviedb.png',
                width: 130.0,
                height: 130.0,
              ),
              Padding(padding: const EdgeInsets.all(7.0)),
              new ListTile(
                title: new TextFormField(
                  controller: _movieNameController,
                  decoration: new InputDecoration(
                      labelText: 'Enter Movie Name',
                      hintText: 'eg: The Punshier, Cars ....',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.5),
                      )),
                ),
              ),
              new ListTile(
                title: new Material(
                  color: Colors.lightBlue,
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(25.0),
                  child: new MaterialButton(
                    onPressed: () {
                      Navigator.of(context)
                          .push(new MaterialPageRoute(builder: (context) {
                        return new SecondPage(
                          movieName: _movieNameController.text,
                        );
                      }));
                    },
                    child: Text(
                      'Search',
                      style: new TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
