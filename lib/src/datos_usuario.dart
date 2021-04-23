import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_appc2/models/LoginModel.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

class DatosUsuario extends StatefulWidget {
  String user;
  String password;
  DatosUsuario(String user, String password){
    this.user = user;
    this.password = password;
  }
  @override
  _DatosUsuarioState createState() => _DatosUsuarioState(user, password);
}

class _DatosUsuarioState extends State<DatosUsuario> {
  String user;
  String password;
  _DatosUsuarioState(String user, String password){
    this.user = user;
    this.password = password;
  }
  RegExp regex = new RegExp(r'^([A-z]|[0-9])+@[A-z]*.com$');
  String _name = "";
  String _lastname = "";
  String _phone = "";
  String _address = "";
  String _email = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              name(),
              lastname(),
              phone(),
              address(),
              email(),
              _button()
            ],
          ),
        ),
      ),
      
    );
  }

  Container name(){
    return Container(
      width: 350,
      padding: EdgeInsets.all(10.0),
      child: TextField(
        onChanged: (text){
          _name = text;
        },
        decoration: InputDecoration(
          labelText: "Nombre",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
          filled: true,
          contentPadding: EdgeInsets.only(top: 40),
          prefixIcon: Icon(Icons.person),
          hintStyle: TextStyle(color: Colors.black)
        ),
      ),
    );
  }

  Container lastname(){
    return Container(
      width: 350,
      padding: EdgeInsets.all(10.0),
      child: TextField(
        onChanged: (text){
          _lastname = text;
        },
        decoration: InputDecoration(
          labelText: "Apellidos",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
          filled: true,
          contentPadding: EdgeInsets.only(top: 40),
          prefixIcon: Icon(Icons.person),
          hintStyle: TextStyle(color: Colors.black)
        ),
      ),
    );
  }

  Container phone(){
    return Container(
      width: 350,
      padding: EdgeInsets.all(10.0),
      child: TextField(
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        onChanged: (text){
          _phone = text;
        },
        decoration: InputDecoration(
          labelText: "Numero telefonico",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
          filled: true,
          contentPadding: EdgeInsets.only(top: 40),
          prefixIcon: Icon(Icons.phone),
          hintStyle: TextStyle(color: Colors.black)
        ),
      ),
    );
  }

  Container address(){
    return Container(
      width: 350,
      padding: EdgeInsets.all(10.0),
      child: TextField(
        onChanged: (text){
          _address = text;
        },
        decoration: InputDecoration(
          labelText: "Direccion",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
          filled: true,
          contentPadding: EdgeInsets.only(top: 40),
          prefixIcon: Icon(Icons.map_sharp),
          hintStyle: TextStyle(color: Colors.black)
        ),
      ),
    );
  }

  Container email(){
    return Container(
      width: 350,
      padding: EdgeInsets.all(10.0),
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        onChanged: (text){
          _email = text;
        },
        decoration: InputDecoration(
          labelText: "Correo electronico",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
          filled: true,
          contentPadding: EdgeInsets.only(top: 40),
          prefixIcon: Icon(Icons.email),
          hintStyle: TextStyle(color: Colors.black)
        ),
      ),
    );
  }

  Container _button(){
    return Container(
      width: 350,
      padding: EdgeInsets.only(left: 80, right: 80),
      child: ElevatedButton(
        onPressed: (){

          if (_address == "" || _name == "" || _lastname == "" || _phone == "" || _email == ""){
            Toast.show("Hay campos vacios", context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
          } else if (_phone.length < 10 || _phone.length > 10) {
            Toast.show("El numero es incorrecto", context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
          } else if (!regex.hasMatch(_email)) {
            Toast.show("Correo erroeneo", context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
          } else {
            singIn(user, password);
          }
        },
        child: Text("Guardar", style: TextStyle(color: Colors.white)),
      ),
    );
  }

  singIn(String emai, String pass) async{
    String url = "http://34.239.109.204/api/v1/login/";
    Map<String, String> params = {
      "username": emai,
      "password": pass
    };
    Map<String, String> header = {
      HttpHeaders.contentTypeHeader : "application/json"
    };
    Uri uri = Uri.parse(url);

    final response = await  http.post(uri, headers: header, body:jsonEncode(params));

    if (response.statusCode == 200){
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      LoginModel loginModel = new LoginModel(jsonData["token"], jsonData["user_id"], jsonData["email"], jsonData["name"]);
      adduser(loginModel);
    } else if (response.statusCode == 400) {
      Toast.show("El usuario y la contraseña no coinsiden", context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);
    } else {
      Toast.show("Hay un error en el servidor", context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);
    }
  }

  adduser(LoginModel loginModel) async {
    int id = loginModel.user_id;
    String url = "http://34.239.109.204/api/v1/profile/profile_list/";
    Map<String, String> header = {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Token "+loginModel.token
    };
    Map<String, String> params = {
      "name": _name,
      "lastName": _lastname,
      "phone": _phone,
      "address": _address,
      "user": "$id",
      "email" : _email
    };
    Uri uri = Uri.parse(url);
    final response = await http.post(uri, headers: header, body: jsonEncode(params));
    if (response.statusCode == 200){
      Toast.show("Se creo el suario correctamente", context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);
      Navigator.of(context).pop();
    } else if (response.statusCode == 400) {
      String body = utf8.decode(response.bodyBytes);
      Toast.show(body, context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);
    } else {
      Toast.show("Hay un error en el servidor", context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);
    }
  }
}