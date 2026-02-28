import 'package:flunter/models/game.dart';
import 'package:flutter/material.dart';
import 'package:flunter/widgets/grid_board.dart';

// GameScreen's Widget
class GameScreen extends StatefulWidget {
  final Difficulties difficulty;
  const GameScreen({super.key, required this.difficulty});

  @override
  State<StatefulWidget> createState() => _GameScreenState();
}

// GameScreen's state
class _GameScreenState extends State<GameScreen> {
  late Game _game;

  void _showWinDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Fluntered !'),
        content: Text('Tentatives: ${_game.attempts}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // ferme pop-up
              Navigator.pop(context); // retour menu
            },
            child: const Text('Menu'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // ferme pop-up
              setState(() {
                _game.resetGame();
              });
            },
            child: const Text('Rejouer'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _game = Game(difficulty: widget.difficulty);
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
      body: GridBoard(
        cards: _game.cards,
        onCardTapped: (index) {
          setState(() {
            _game.onCardTapped(index, () {setState(() {});});
            if(_game.isGameOver()) _showWinDialog();
          });
        },
      ),
    );
  }
}