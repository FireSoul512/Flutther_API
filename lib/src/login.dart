import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_appc2/models/LoginModel.dart';
import 'package:flutter_appc2/src/profile_page.dart';
import 'package:flutter_appc2/src/registro.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

class Login extends StatefulWidget{
  @override
  _Login createState() => _Login();

}

String email = "";
String password = "";

Widget buildPassword(){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        'Password',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: 10),
      Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0,2)
            )
          ]
        ),
        height: 60,
        child: TextField(
          obscureText: true,
          onChanged: (value) {
            password = value;
          },
          style: TextStyle(
            color: Colors.black87
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 14),
            prefixIcon: Icon(
              Icons.lock,
              color: Color(0xff0b619c)
            ),
           hintText: 'Password',
           hintStyle: TextStyle(
             color: Colors.black38
           )
          ),
        ),
      )
    ],
  );
}

Widget buildEmail(){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        'Email',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: 10),
      Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0,2)
            )
          ]
        ),
        height: 60,
        child: TextField(
          keyboardType: TextInputType.emailAddress,
          onChanged: (text){
            email = text;
          },
          style: TextStyle(
            color: Colors.black87
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 14),
            prefixIcon: Icon(
              Icons.email,
              color: Color(0xff0b619c)
            ),
           hintText: 'Email',
           hintStyle: TextStyle(
             color: Colors.black38
           )
          ),
        ),
      )
    ],
  );
}

Widget buildLoginBtn(BuildContext context){
  return Container(
    padding: EdgeInsets.symmetric(vertical:25),
    width: double.infinity,
    child: RaisedButton(
      elevation: 5,
      onPressed: (){
        if (email == "" || password == ""){
          Toast.show("Hay campos vacios", context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);
        } else {
          singIn(email, password, context);
        }
        
      },
      padding: EdgeInsets.all(15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15)
       ),
      color: Colors.white,
      child: Text(
        'LOGIN',
        style: TextStyle(
          color: Color(0xff0b619c),
          fontSize: 18,
          fontWeight: FontWeight.bold
        )
      ),
    ),
  );
}

Widget buildSignUpBtn(BuildContext context){
  return GestureDetector(
    onTap: () {
      Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => Registro(),
    ));
    },
    child: RichText(
     text: TextSpan(
       children:[
         TextSpan(
           text: 'No tienes una cuenta?',
           style: TextStyle(
             color : Colors.white,
             fontSize: 18,
             fontWeight: FontWeight.w500
          ),
        ),
        TextSpan(
          text: 'Sing Up',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold
          )
        )
      ]

     ) 
    ),
  );
}

singIn(String emai, String pass, BuildContext context) async{
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
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => Profile_Page(loginModel),
    ));
  } else if (response.statusCode == 400) {
    Toast.show("El usuario y la contraseña no coinsiden", context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);
  } else {
    Toast.show("Hay un error en el servidor", context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);
  }
}

class _Login extends State<Login>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0x660b619c),
                      Color(0x990b619c),
                      Color(0xcc0b619c),
                      Color(0xff0b619c),
                    ]
                  )
                ),
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 120
                  ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Iniciar sesión',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(height: 50,),
                    buildEmail(),
                    SizedBox(height: 20,),
                    buildPassword(),
                    buildLoginBtn(context),
                    buildSignUpBtn(context),
                  ]
                )
                )
              )
            ],
          )
        )
      ),
    );
  }
}


  