import 'package:blog/authenticate.dart';
import 'package:blog/dialogbox.dart';
import 'package:flutter/material.dart';

class StartUp extends StatefulWidget {
  final AuthImplementation auth;
  final VoidCallback onSignedIn;

  StartUp({this.auth, this.onSignedIn});

  @override
  _StartUpState createState() => _StartUpState();
}

enum FormType { login, register }

class _StartUpState extends State<StartUp> {
  DialogBox dialogBox = new DialogBox();
  final _formkey = new GlobalKey<FormState>();
  FormType _formType = FormType.login;
  String _email = '';

  String _password = '';

  bool validateandsave() {
    final _form = _formkey.currentState;
    if (_form.validate()) {
      _form.save();
      return true;
    } else
      return false;
  }

  void movetoregister() {
    _formkey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

  void validateAndSubmit() async {
    if (validateandsave()) {
      try {
        if (_formType == FormType.login) {
          String userId = await widget.auth.signIn(_email, _password);
          //dialogBox.information(context, 'Congratulation', 'Login Succesful');
        } else {
          String userId = await widget.auth.signUp(_email, _password);
          //dialogBox.information(context, "Congratulations",
          //   'Your account has been created succesfully');
        }
        widget.onSignedIn();
      } catch (e) {
        dialogBox.information(context, "Error = ", e.toString());
        print("Error =" + e.toString());
      }
    }
  }

  void movetologin() {
    _formkey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text(
          'Blog App',
          style: TextStyle(letterSpacing: 2),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(5),
          child: Form(
              key: _formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: createInput() + createButton(),
              )),
        ),
      ),
    );
  }

  List<Widget> createInput() {
    return [
      SizedBox(
        height: 10.0,
      ),
      logo(),
      SizedBox(
        height: 20,
      ),
      new TextFormField(
        decoration: InputDecoration(hintText: 'Email'),
        validator: (value) {
          return value.isEmpty ? ' Enter Email' : null;
        },
        onSaved: (value) {
          return _email = value;
        },
      ),
      SizedBox(
        height: 10.0,
      ),
      new TextFormField(
        obscureText: true,
        decoration: InputDecoration(labelText: 'Password'),
        validator: (value) {
          return value.isEmpty ? ' Enter Password' : null;
        },
        onSaved: (value) {
          return _password = value;
        },
      ),
      SizedBox(
        height: 20.0,
      )
    ];
  }

  Widget logo() {
    return Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.redAccent,
        radius: 110.0,
        //child: Image.asset('name'),
      ),
    );
  }

  List<Widget> createButton() {
    if (_formType == FormType.login) {
      return [
        new RaisedButton(
          onPressed: validateAndSubmit,
          child: Text(
            'Login',
            style: TextStyle(fontSize: 20.0, color: Colors.pink),
          ),
        ),
        new FlatButton(
          onPressed: movetoregister,
          child: Text(
            'Not Have an Acccount? Create New one',
            style: TextStyle(fontSize: 14.0, color: Colors.red),
          ),
        ),
      ];
    } else {
      return [
        new RaisedButton(
          onPressed: validateAndSubmit,
          child: Text(
            'Create Account',
            style: TextStyle(fontSize: 20.0, color: Colors.pink),
          ),
        ),
        new FlatButton(
          onPressed: movetologin,
          child: Text(
            'Already hav an Account? Login Now',
            style: TextStyle(fontSize: 14.0, color: Colors.red),
          ),
        ),
      ];
    }
  }
}
