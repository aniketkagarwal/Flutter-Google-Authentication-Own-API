import 'package:flutter/material.dart';
import 'package:gmail/Module/Login/login_view.dart';

void main() => runApp(
  new MaterialApp(
    title: 'Google Authentication',
    theme: new ThemeData(
      primarySwatch: Colors.blue
    ),
    home: new LoginPage()
  )
);