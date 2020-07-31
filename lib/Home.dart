import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:teste_pji3_get/Dados.dart';

/*
* Maneira simples de implementar o GET
*
* */

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String _urlF = "http://10.0.2.2:5000/api/v1/teste";
  String _urlS = "http://10.0.2.2:42069/2";

  Future<List<Map<String, dynamic>>> _get() async {
    String url = "http://10.0.2.2:5000/api/v1/teste";
    http.Response response = await http.get(url);
    return json.decode( response.body );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List>(
      future: _get(),
      builder: (context, snapshot){
        String resultado;
        switch( snapshot.connectionState ){
          case ConnectionState.none :
          case ConnectionState.waiting :
            print("conexao waiting");
            resultado = "Carregando...";
            break;
          case ConnectionState.active :
          case ConnectionState.done :
            print("conexao done");
            if( snapshot.hasError ){
              resultado = "Erro ao carregar os dados. 123";
            }else {
              double valor = snapshot.data[0]["date"];
              resultado = "Preço do bitcoin: ${valor.toString()} ";
            }
            break;
        }
        return Center(
          child: Text( resultado ),
        );
      },
    );
  }
}
