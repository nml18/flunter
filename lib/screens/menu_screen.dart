import 'package:flunter/models/game.dart';
import 'package:flutter/material.dart';
import 'game_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  void _navigateToGame(BuildContext context, Difficulties difficulty) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameScreen(difficulty: difficulty),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FLUNTER'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildDifficultyButton(context, 'Easy', Difficulties.easy),
            const SizedBox(height: 16),
            _buildDifficultyButton(context, 'Medium', Difficulties.medium),
            const SizedBox(height: 16),
            _buildDifficultyButton(context, 'Hard', Difficulties.hard),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultyButton(BuildContext context, String label, Difficulties difficulty){
    return ElevatedButton(
      onPressed: () => _navigateToGame(context, difficulty),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(200, 50),
      ),
      child: Text(label),
    );
  }
}