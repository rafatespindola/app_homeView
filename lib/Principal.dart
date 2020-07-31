import 'package:teste_pji3_get/Dados.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

/*
* Maneira melhorada de implementar o GET
*
* */

class Principal extends StatefulWidget {
  @override
  _PrincipalState createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {

  String _url = "http://10.0.2.2:5000/api/v1/teste";

  Future<List<Dados>> _get() async {
    http.Response response = await http.get(_url);
    var dadosJson = json.decode(response.body);
    List<Dados> lDados = List();
    for(var aux in dadosJson){
      Dados d = Dados(aux["date"], aux["temp"], aux["uid"], aux["umidade"]);
      lDados.add( d );
    }
    return lDados;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Projeto Integrador 3",
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(2),
        child: Column(
          children: <Widget>[
            Expanded(
              child: FutureBuilder<List<Dados>>(
                future: _get(),
                //ignore: missing_return
                builder: (context, snapshot){
                  switch(snapshot.connectionState){
                    case ConnectionState.none :
                    case ConnectionState.waiting :
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    case ConnectionState.active :
                    case ConnectionState.done :
                      if(snapshot.hasError){
                        print("Lista de fucking Dados com fucking erro");
                      }else{
                        return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index){
                            Dados dado = snapshot.data[index];
                            return ListTile(
                              title: Text(dado.date),
                              subtitle: Text(dado.temp.toString()),
                            );
                          }
                        );
                      }
                  }
                }
              ),
            )
          ],
        ),
      ),
    );
  }
}



