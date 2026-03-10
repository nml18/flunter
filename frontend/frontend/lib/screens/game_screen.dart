import 'package:flunter/models/game.dart';
import 'package:flutter/material.dart';
import 'package:flunter/widgets/grid_board.dart';
import 'dart:async';

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
  late Timer _timer;
  int _elapsedMilliseconds = 0; 
  bool _gameStarted = false;

  void _showWinDialog(BuildContext gameScreenContext) {
    _timer.cancel();
    
    showDialog(
      context: gameScreenContext,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) { 
        return AlertDialog(
          title: const Text('Fluntered !'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Tentatives: ${_game.attempts}'),
              const SizedBox(height: 8),
              Text('Temps: ${_formatTime(_elapsedMilliseconds)}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                Navigator.pop(gameScreenContext);
              },
              child: const Text('Menu'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                setState(() {
                  _game.resetGame();
                  _elapsedMilliseconds = 0;  
                  _gameStarted = false;
                });
              },
              child: const Text('Restart'),
            ),
          ],
        );
      },
    );
  }

  void _startTimerIfNeeded() {
    if (!_gameStarted) {
      _gameStarted = true;
      _timer = Timer.periodic(const Duration(milliseconds: 10), (_) {
        setState(() => _elapsedMilliseconds += 10);
      });
    }
  }

  void _checkGameOver() {
    if (_game.isGameOver()) {
      _timer.cancel();
      _showWinDialog(context);
    }
  }

  String _formatTime(int milliseconds) {
    int totalSeconds = milliseconds ~/ 1000;
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    int hundredths = (milliseconds % 1000) ~/ 10; 
    
    return '${minutes.toString().padLeft(2, '0')}:'
           '${seconds.toString().padLeft(2, '0')}:'
           '${hundredths.toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    _game = Game(difficulty: widget.difficulty);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Temps: ${_formatTime(_elapsedMilliseconds)}'),
          ),
        ],
      ),
      body: GridBoard(
        cards: _game.cards,
        onCardTapped: (index) {
          setState(() {
            _game.onCardTapped(index, () {setState(() {});});
            _startTimerIfNeeded();
            _checkGameOver();
          });
        },
      ),
    );
  }
}