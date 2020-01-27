import 'dart:async';
import 'dart:convert';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

import 'package:http/http.dart' as http;

_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

Future<Token> getToken(String appId, String appSecret) async {
  Stream<String> onCode = await _server();
  String url = "https://accounts.google.com/signin/oauth/oauthchooseaccount?client_id=$appId&as=8touwVoG7T7g2bDbrzM7Qg&destination=https%3A%2F%2Fgoogle-gmail.auth0.com&approval_state=!ChRBMmtmbHMwb2dpTDlBbUdSbkNLbhIfQTBuSkNEd0NhRDRVOEhuU1JuY2dubXFld2Mxc19oWQ%E2%88%99AJDr988AAAAAXjAdfwPxEo5WTXMm5Z7PwLT8i9RrLc6E&oauthgdpr=1&xsrfsig=ChkAeAh8T0lQSkNgEtq8NaqHxO76J248QCUCEg5hcHByb3ZhbF9zdGF0ZRILZGVzdGluYXRpb24SBXNvYWN1Eg9vYXV0aHJpc2t5c2NvcGU&flowName=GeneralOAuthFlow";
  final flutterWebViewPlugin = new FlutterWebviewPlugin();
  //flutterWebViewPlugin.launch(url);
  _launchURL(url);
  final String code = await onCode.first;
  final http.Response response = await http.post("https://oauth2.googleapis.com/token", body: {"client_id": appId, "redirect_uri": "", "client_secret": appSecret, "code": code, "grant_type": "authorization_code"});
  flutterWebViewPlugin.close();
  return new Token.fromMap(jsonDecode(response.body));
}

Future<Stream<String>> _server() async {
  final StreamController<String> onCode = new StreamController();
  HttpServer server = await HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 8585);
  server.listen((HttpRequest request) async {
    final String code = request.uri.queryParameters["code"];
    request.response
      ..statusCode = 200
      ..headers.set("Content_Type", ContentType.HTML.mimeType)
      ..write("<html><h1>You can now close this window.</h1></html>");
    await request.response.close();
    await server.close(force: true);
    onCode.add(code);
    await onCode.close();
  });
  return onCode.stream;
}

class Token {
  String access;
  String id;
  String username;
  String full_name;
  String profile_picture;

  Token.fromMap(Map json){
    access = json['access_token'];
    id = json['user']['id'];
    username = json['user']['username'];
    full_name = json['user']['full_name'];
    profile_picture = json['user']['profile_picture'];
  }
}
