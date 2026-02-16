import 'package:flutter/material.dart';

class GameScreen extends StatelessWidget{
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
          title: Align(
            alignment: Alignment.centerLeft,
            child: Text('Flunter'),
          ),
        ),
        body: Center(child: Text('Cards TODO')),
    );
  }
}