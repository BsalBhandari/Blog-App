import 'package:blog/authenticate.dart';
import 'package:blog/photoupload.dart';
import 'package:blog/post.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  final AuthImplementation auth;
  final VoidCallback onSignOut;
  Home({
    this.auth,
    this.onSignOut,
  });
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void _logOutUser() async {
    try {
      await widget.auth.signOut();
      widget.onSignOut();
    } catch (e) {
      print(e.toString());
    }
  }

  List<Posts> postList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DatabaseReference postsRef =
        FirebaseDatabase.instance.reference().child('Posts');
    postsRef.once().then((DataSnapshot snapshot) {
      var KEYS = snapshot.value.keys;
      var DATA = snapshot.value;

      postList.clear();
      for (var individualKey in KEYS) {
        Posts posts = new Posts(
          DATA[individualKey]['images'],
          DATA[individualKey]['description'],
          DATA[individualKey]['date'],
          DATA[individualKey]['time'],
        );
        postList.add(posts);
      }

      setState(() {
        print('Lenghts : ${postList.length}');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text(
          'Home',
          style: TextStyle(letterSpacing: 2),
        ),
        centerTitle: true,
      ),
      body: new Container(
          child: postList.length == 0
              ? new Text("No Blog Post available")
              : new ListView.builder(
                  itemCount: postList.length,
                  itemBuilder: (_, index) {
                    return PostsUI(
                      postList[index].image,
                      postList[index].description,
                      postList[index].date,
                      postList[index].time,
                    );
                  },
                )),
      bottomNavigationBar: new BottomAppBar(
        color: Colors.pink,
        child: new Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new IconButton(
                  icon: Icon(Icons.local_car_wash),
                  iconSize: 50,
                  color: Colors.white,
                  onPressed: _logOutUser),
              new IconButton(
                  icon: Icon(Icons.photo),
                  iconSize: 40,
                  color: Colors.white,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return UploadPhoto();
                    }));
                  })
            ],
          ),
        ),
      ),
    );
  }

  Widget PostsUI(String image, String description, String date, String time) {
    return new Card(
      elevation: 10.0,
      margin: EdgeInsets.all(15),
      child: new Container(
        padding: new EdgeInsets.all(14),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Text(
                  date,
                  style: Theme.of(context).textTheme.subtitle1,
                  textAlign: TextAlign.center,
                ),
                new Text(
                  time,
                  style: Theme.of(context).textTheme.subtitle1,
                  textAlign: TextAlign.center,
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            new Image.network(
              image,
              fit: BoxFit.cover,
            ),
            SizedBox(
              height: 10,
            ),
            new Text(
              time,
              style: Theme.of(context).textTheme.subhead,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
