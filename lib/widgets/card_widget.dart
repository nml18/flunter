import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CardWidget extends StatefulWidget{
  const CardWidget({super.key});
  @override
  State<StatefulWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget>{
  bool _isHovered = false;

  @override
  Widget build(BuildContext context){
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child : Card(
        elevation: _isHovered ? 10 : 5,
        surfaceTintColor: Colors.orange,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: _isHovered ? Colors.red : Colors.blueGrey,
            width: _isHovered ? 3 : 2),
        ),
        child: SizedBox(
          width: 80,
          height: 120,
          child: SvgPicture.asset(
            'icons/question_marks/black.svg'
          ),
        ),
      )
    );
  }
}