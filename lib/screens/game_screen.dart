import 'package:flunter/models/game.dart';
import 'package:flutter/material.dart';
import 'package:flunter/widgets/card_widget.dart';

class GameScreen extends StatefulWidget{
  const GameScreen({super.key});

  @override
  State<StatefulWidget> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late Game _game;  

  @override
  void initState() {
    super.initState();
    _game = Game(difficulty: Difficulties.easy);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flunter'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Tentatives: ${_game.attempts}'),
          ),
        ],
      ),
      body: const CardWidget(),
    );
  }
}