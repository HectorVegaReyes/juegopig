import 'dart:core';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Juego de Pig'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int scorePlayer = 0;
  int scoreComputer = 0;
  bool turnComputer = false;
  int jugador = 1;
  int turnScore = 0;
  int dieValue = 0;
  final scoreWin = 100;
  bool terminaTurno = false;
  List<Map<String,dynamic>> players = [
    {"value": 0, "tittle": "Computadora"},
    {"value": 1, "tittle": "Jugador"},
  ];
  List<Map<String, dynamic>> die = [
    {"value": 0, "tittle": "GO", "color": Colors.pinkAccent},
    {"value": 1, "tittle": "🐷", "color": Colors.yellowAccent},
    {"value": 2, "tittle": "2", "color": Colors.blueAccent},
    {"value": 3, "tittle": "3", "color": Colors.redAccent},
    {"value": 4, "tittle": "4", "color": Colors.greenAccent},
    {"value": 5, "tittle": "5", "color": Colors.orangeAccent},
    {"value": 6, "tittle": "6", "color": Colors.purpleAccent},
  ];

  void _mostrarAlerta(BuildContext context, String mensaje) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(mensaje),
            content: Text(mensaje),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Aceptar"),
              ),
            ],
          );
          },);
    }
  void _mostrarAlertaPig(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Encontraste un uno y recibiste un puerquito 🐷'),
          content: const Text('Perdiste los puntos acumulados en el turno '),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  scorePlayer=0;
                  scoreComputer=0;
                  dieValue = 0;
                  turnComputer = false;
                  jugador = 1;
                });
              },
              child: const Text("Aceptar"),
            ),
          ],
        );
      },);
  }

  void winner(){
    if(turnComputer){
      if(scoreComputer>=scoreWin){
          _mostrarAlerta(context, "Gano la computadora");
      }
    }else{
      if(scorePlayer>=scoreWin){
        _mostrarAlerta(context, "Felicidades🥳, Ganaste");
      }
    }
  }

  void endTurn() {
    if(!terminaTurno){
      return;
    }
    if (turnComputer) {
      setState(() {
        scoreComputer += turnScore;
        winner();
        turnComputer = !turnComputer;
        jugador = 1;
      });
    } else {
      setState(() {
        scorePlayer += turnScore;
        winner();
        turnComputer = !turnComputer;
        jugador = 0;
      });
      computerTurn();
    }
    setState(() {
      dieValue = 0;
      turnScore = 0;
    });
  }

  void shakeDice() {
    terminaTurno = true;
    int random = Random().nextInt(6) + 1;
    if(turnComputer && (turnScore+random)>=20 ){
      setState(() {
        endTurn();
        return;
      });
    }
    if (random == 1) {
      setState(() {
        turnScore = 0;
        dieValue = random;
      });
      endTurn();
      _mostrarAlertaPig(context);
      return;
    }
    setState(() {
      turnScore += random;
      dieValue = random;
    });
  }

  void computerTurn() {
    if (turnComputer) {
      Future.delayed(const Duration(seconds: 1), () {
        shakeDice();
        computerTurn();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          centerTitle: true,
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                const Text(
                  'Acumulado',
                ),
                Container(
                  width: 100,
                  height: 120,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black, // Color del borde
                      width: 2, // Ancho del borde
                    ),
                  ),
                  child: Center(
                      child: Text(scorePlayer.toString(), style: const TextStyle(fontSize: 20))),
                ),
                const Text("Jugador 1"),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Turno',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(players[jugador]["tittle"] as String),
                const SizedBox(
                    height: 20), // Espacio entre el texto y los contenedores
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: shakeDice,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: die[dieValue]["color"], // color actual
                          border:
                              Border.all(color: Colors.black, width: 3), //borde
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            die[dieValue]['tittle'] as String,
                            style: const TextStyle(
                              fontSize: 24,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black, // Color del borde
                          width: 2, // Ancho del borde
                        ),
                      ),
                      child: Center(
                        child: Text(
                          turnScore.toString(),
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                    height: 20), // Espacio entre los contenedores y el botón
                ElevatedButton(
                  onPressed: () {
                    endTurn();
                  },
                  child: const Text("Terminar Turno"),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Acumulado',
                ),
                Container(
                  width: 100,
                  height: 120,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black, // Color del borde
                      width: 2, // Ancho del borde
                    ),
                  ),
                  child: Center(
                      child: Text(scoreComputer.toString(), style: const TextStyle(fontSize: 20))),
                ),
                const Text("Jugador 2"),
              ],
            ),
          ],
        ));
  }
}
