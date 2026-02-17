import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget{
  const CardWidget({super.key});

  @override
  Widget build(BuildContext context){
    return Center(
      child:  Container(
        width: 80,
        height: 120,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: 5,
          ),
        ),
        child: Text(
          '?',
          style: TextStyle(
            color: Colors.orange,
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}