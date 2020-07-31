import 'package:teste_pji3_get/Dados.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:flutter/painting.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
/*
* Versão com gráfico feio e list view embaixo
* */

class Graficos extends StatefulWidget {
  @override
  _GraficosState createState() => _GraficosState();
}

class _GraficosState extends State<Graficos> {

  String _url = "http://10.0.2.2:5000/api/v1/teste";
  //List<Dados> _lDados = List();

  Future<List<Dados>> _get() async {
    http.Response response = await http.get(_url);
    var dadosJson = json.decode(response.body);
    List<Dados> lDados = List();
    for(var aux in dadosJson){
      Dados d = Dados(aux["date"], aux["temp"], aux["uid"], aux["umidade"]);
      lDados.add( d );
    }
//    setState(() {
//      _lDados = lDados;
//    });
    return lDados;
  }

//  List<double> _lTemp(List<Dados> lDados){
//    List<double> lTemp;
//    for(int i=0; i<lDados.length; i++){
//      lTemp.add(lDados[i].temp);
//    }
//    return lTemp;
//  }

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
                      List<double> _lTemp = List();
                      for(int i=0; i<snapshot.data.length; i++){
                        _lTemp.add(snapshot.data[i].temp);
                      }
                      return Container(
                        height: 300,
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Sparkline(
                            data: _lTemp,//TODO
                            lineColor: Colors.black,
                            pointColor: Colors.blue,
                            pointsMode: PointsMode.all,
                            pointSize: 8.0,
                            fillMode: FillMode.below, //preenchimento abaixo
                            fillGradient: new LinearGradient(
                              colors: [Colors.red, Colors.blue],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      );
                  }
                },
              ),
            ),
            Divider(),
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
                                  subtitle: Text(
                                    "Temperatura: " + dado.temp.toString()
                                          + " " +
                                    "Umidade: " + dado.umidade.toString()
                                  ),
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

