import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flunter/constants/icon_categories.dart';
import 'dart:math';

class CardWidget extends StatefulWidget {
  final bool isFaceUp;
  final VoidCallback onTap;
  final String iconPath;
  static final String iconCategory = iconCategories[Random().nextInt(iconCategories.length)];

  const CardWidget({
    super.key,
    required this.isFaceUp,
    required this.onTap,
    required this.iconPath,
  });

  @override
  State<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Card(
          elevation: _isHovered ? 10 : 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: Colors.blueGrey,
              width: _isHovered ? 3 : 2,
            ),
          ),
          child: SizedBox(
            child: widget.isFaceUp
                ? SvgPicture.asset(widget.iconPath)
                : SvgPicture.asset('icons/question_marks/black.svg'),
          ),
        ),
      ),
    );
  }
}