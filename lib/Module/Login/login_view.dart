import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'package:gmail/Module/Login/login_presenter.dart';
import 'package:gmail/google.dart';

class LoginPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text("Flutter Google Authentication"),
      ),
      body: new LoginScreen(_scaffoldKey)
    );
  }
}

class LoginScreen extends StatefulWidget {
  GlobalKey<ScaffoldState> skey;
  LoginScreen(GlobalKey<ScaffoldState> this.skey, {Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => new _LoginScreenState(skey);
}

class _LoginScreenState extends State<LoginScreen> implements LoginViewContract {
  LoginPresenter _presenter;
  bool _IsLoading;
  Token token;

  GlobalKey<ScaffoldState> _scaffoldKey;

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(value)
    ));
  }

  _LoginScreenState(GlobalKey<ScaffoldState> skey) {
    _presenter = new LoginPresenter(this);
    _scaffoldKey = skey;
  }

  @override
  void initState() {
    super.initState();
    _IsLoading = false;
  }

  @override
  void onLoginError(String msg) {
    setState(() {
      _IsLoading = false;
    });
    showInSnackBar(msg);
  }

  @override
  void onLoginSuccess(Token t) {
    setState(() {
      _IsLoading = false;
      token = t;
    });
    showInSnackBar('Login successful');
  }

  @override
  Widget build(BuildContext context) {
    var widget;
    if(_IsLoading) {
      widget = new Center(
        child: new Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: new CircularProgressIndicator()
        )
      );
    } else if(token != null){
      widget = new Padding(
        padding: new EdgeInsets.all(32.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Text(
              token.full_name,
              style: DefaultTextStyle.of(context).style.apply(
                fontSizeFactor: 1.5
              ),
            ),
            new Text(token.username),
            new Center(
              child: new CircleAvatar(
                backgroundImage: new NetworkImage(token.profile_picture),
                radius: 50.0,
              ),
            ),
          ]
        )
      );
    }
    else {
      widget = new Padding(
        padding: new EdgeInsets.all(32.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Text(
              'Welcome to Myapp',
              style: DefaultTextStyle.of(context).style.apply(
                fontSizeFactor: 1.5
              ),
            ),
            new Text('Login to continue'),
            new Center(
              child: new Padding(
                padding: new EdgeInsets.symmetric(vertical: 160.0),
                child: new InkWell(child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    new Image.asset(
                      'assets/google.png',
                      height: 50.0,
                      fit: BoxFit.cover,
                    ),
                    new Text('Continue with Gmail')
                  ],
                ),onTap: _login,)
              ),
            ),
          ]
        )
      );
    }
    return widget;
  }

  void _login(){
    setState(() {
      _IsLoading = true;
    });
    _presenter.perform_login();
  }
}