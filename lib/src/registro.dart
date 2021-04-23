import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_appc2/src/datos_usuario.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

class Registro extends StatefulWidget {
  @override
  _RegistroState createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  String usuario = "";
  String password = "";
  String password_confirm = "";
  bool mostrarPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: new BoxDecoration(
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

        child: Column(
          
           mainAxisAlignment: MainAxisAlignment.center,

          children: <Widget>[

            SizedBox(height: 30,),

            Text("Registro", style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w500,
            ), 
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 10,),

            TextField(
              onChanged: (texto){
                usuario = texto;
              },

              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
                hintText: 'Ingrese Email',
                icon: Icon(
                  Icons.mail_outline,
                  color: Colors.white,
                ),
              ),
            ),

            SizedBox(height: 10,),

            TextField(
              onChanged: (texto){
                password = texto;
              },
              
              obscureText: !this.mostrarPassword,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                suffixIcon: IconButton(icon: Icon(
                  Icons.remove_red_eye,
                  color: this.mostrarPassword ? Colors.blue : Colors.grey,
                ), 
                
                onPressed: (){this.mostrarPassword = !this.mostrarPassword;}
                ),

                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
                hintText: 'Ingrese Contraseña',
                icon: Icon(
                  Icons.lock,
                  color: Colors.white,
                
                ),
              ),
            ),

            SizedBox(height: 10,),

            TextField(
              onChanged: (texto){
                password_confirm = texto;
              },
              
              obscureText: !this.mostrarPassword,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                suffixIcon: IconButton(icon: Icon(
                  Icons.remove_red_eye,
                  color: this.mostrarPassword ? Colors.blue : Colors.grey,
                ), 
                
                onPressed: (){this.mostrarPassword = !this.mostrarPassword;}
                ),

                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
                hintText: 'Confirme contraseña',
                icon: Icon(
                  Icons.lock,
                  color: Colors.white,
                
                ),
              ),
            ),

            SizedBox(height: 10,),

            ElevatedButton(
              onPressed:(){
                if (usuario == "" || password == "" || password_confirm == ""){
                  Toast.show("Hay campos vacios", context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);
                } else if (password != password_confirm){
                  Toast.show("Las contraseñas no coinciden", context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);
                } else {
                  singUp(usuario, password, context);
                }
                
              },
              child:Text(
                'Iniciar sesión',
                style: TextStyle(color: Colors.white,
                ),
              ),

              style: ButtonStyle(

                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                        return Color.fromRGBO(
                       11,97,156,1.0); 
                      },
                    ),
                  
                ),
              
            ),

            SizedBox(height: 40,),
            buildSignUpBtn(context)
            
          ],  
        ),

      ),
    );
  }
}

Widget buildSignUpBtn(BuildContext context){
  return GestureDetector(
    onTap: () {
      Navigator.of(context).pop();
    },
    child: RichText(
     text: TextSpan(
       children:[
         TextSpan(
           text: 'Regresar',
           style: TextStyle(
             color : Colors.white,
             fontSize: 18,
             fontWeight: FontWeight.w500
          ),
        ),
      ]

     ) 
    ),
  );
}

singUp(String email, String password, BuildContext context) async{
  String url = "http://34.239.109.204/api/v1/registration/";
  print(email);
  Map<String, String> params = {
    "username": email,
    "password1": password,
    "password2": password
  };

  Map<String, String> header = {
    HttpHeaders.contentTypeHeader : "application/json"
  };

  Uri uri = Uri.parse(url);

  final response = await  http.post(uri, headers: header, body:jsonEncode(params));
  String body = utf8.decode(response.bodyBytes);
  final jsonData = jsonDecode(body);
  print(jsonData);
  if (response.statusCode == 200 || response.statusCode == 201){
    Toast.show("Se ha creado tu cuenta", context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);
    Navigator.of(context).pop();
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => DatosUsuario(email, password),
    ));
  } else if (response.statusCode == 400) {
    Toast.show(body, context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);
  } else {
    Toast.show("Hay un error en el servidor", context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);
    Navigator.of(context).pop();
  }
}