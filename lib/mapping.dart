import 'package:flutter/material.dart';
import 'startup.dart';
import 'home.dart';
import 'authenticate.dart';

class MappingPage extends StatefulWidget {
  final AuthImplementation auth;

  MappingPage({
    this.auth,
  });
  @override
  _MappingPageState createState() => _MappingPageState();
}

enum AuthStatus {
  notSignIn,
  signIn,
}

class _MappingPageState extends State<MappingPage> {
  AuthStatus _authStatus = AuthStatus.notSignIn;

  @override
  void initState() {
    widget.auth.getCurrentUser().then((firebaseUserId) {
      setState(() {
        _authStatus =
            firebaseUserId == null ? AuthStatus.notSignIn : AuthStatus.signIn;
      });
    });
    super.initState();
  }

  void _signOut() {
    setState(() {
      _authStatus = AuthStatus.notSignIn;
    });
  }

  void _signIn() {
    setState(() {
      _authStatus = AuthStatus.signIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_authStatus) {
      case AuthStatus.notSignIn:
        return new StartUp(
          auth: widget.auth,
          onSignedIn: _signIn,
        );
      case AuthStatus.signIn:
        return new Home(
          auth: widget.auth,
          onSignOut: _signOut,
        );
    }
  }
}
