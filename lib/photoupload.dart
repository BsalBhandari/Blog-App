import 'package:blog/home.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UploadPhoto extends StatefulWidget {
  @override
  _UploadPhotoState createState() => _UploadPhotoState();
}

class _UploadPhotoState extends State<UploadPhoto> {
  File sampleImage;

  Future getImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      sampleImage = tempImage;
    });
  }

  bool validateandSave() {
    final form = formkey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
  }

  final formkey = GlobalKey<FormState>();
  String _myvalue;
  String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text('Upload'),
        centerTitle: true,
      ),
      body: new Center(
        child: sampleImage == null ? Text('Select an Image') : enableUpload(),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Add Image',
        child: new Icon(Icons.add_a_photo),
      ),
    );
  }

  Widget enableUpload() {
    return new Container(
      child: new Form(
          key: formkey,
          child: Column(
            children: <Widget>[
              Image.file(
                sampleImage,
                height: 330.0,
                width: 660.0,
              ),
              SizedBox(
                height: 15.0,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
                validator: (value) {
                  return value.isEmpty ? 'Description is Required' : null;
                },
                onSaved: (newValue) {
                  return _myvalue = newValue;
                },
              ),
              SizedBox(
                height: 15.0,
              ),
              RaisedButton(
                onPressed: uploadStausImage,
                elevation: 10.0,
                child: Text('Add a New Post'),
                textColor: Colors.white,
                color: Colors.pink,
              )
            ],
          )),
    );
  }

  void uploadStausImage() async {
    if (validateandSave()) {
      final StorageReference postImageRef =
          FirebaseStorage.instance.ref().child('Post Image');
      var timekey = new DateTime.now();
      final StorageUploadTask uploadTask =
          postImageRef.child(timekey.toString()).putFile(sampleImage);
      var ImageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
      url = ImageUrl.toString();

      saveToDatabase(url);
      goToHomePage();
    }
  }

  void saveToDatabase(url) {
    var dbTimekey = new DateTime.now();
    var formatDate = new DateFormat("MMM d , yyyy");
    var formatTime = new DateFormat("EEEE , hh:mm aaa");
    String date = formatDate.format(dbTimekey);
    String time = formatTime.format(dbTimekey);

    DatabaseReference dbref = FirebaseDatabase.instance.reference();
    var data = {
      "image": url,
      "descripion": _myvalue,
      "date": date,
      "time": time
    };
    dbref.child("Posts").push().set(data);
  }

  void goToHomePage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return new Home();
    }));
  }
}
