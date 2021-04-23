import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_appc2/models/LoginModel.dart';
import 'package:flutter_appc2/models/User.dart';
import 'package:http/http.dart' as http;

class Profile_Page extends StatefulWidget {
  final LoginModel login;
  Profile_Page(this.login);

  @override
  _State createState() => _State(this.login);
}

class _State extends State<Profile_Page> {
  final LoginModel _loginModel;
  Future<User> _user;

  Future<User> _getUser() async{
    int id = _loginModel.user_id;
    String url = "http://34.239.109.204/api/v1/profile/profile_detail/$id";
    Map<String, String> header = {
      HttpHeaders.contentTypeHeader:"application/json",
      HttpHeaders.authorizationHeader:"Token "+_loginModel.token
    };
    Uri uri = Uri.parse(url);
    final response = await http.get(uri, headers: header);
    if (response.statusCode == 200){
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      User user = new User(
        jsonData[0]["id"], 
        jsonData[0]["name"], 
        jsonData[0]["lastName"], 
        jsonData[0]["phone"], 
        jsonData[0]["address"], 
        jsonData[0]["email"],
        jsonData[0]["user"]
      );
      return user;
    } else {
      throw Exception("Error");
    }
  }

  _State(this._loginModel);

  @override
  void initState() {
    _user = _getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Usuario"),
      ),
      body: FutureBuilder(
        future: _user,
        builder: (context, snapshot) {
          if (snapshot.hasData){
            return _center(snapshot.data);
          } else if (snapshot.hasError){
            return Center(
              child: Text("Error"),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Center _center(User data){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(data.name),
          SizedBox(height: 10),
          Text(data.lastname),
          SizedBox(height: 10),
          Text(data.phone),
          SizedBox(height: 10),
          Text(data.address),
          SizedBox(height: 10),
          Text(data.email)
        ],
      ),
    );
  }
}

