import 'package:flutter/material.dart';
import 'package:flunter/models/game_card.dart';
import 'package:flunter/widgets/card_widget.dart';

class GridBoard extends StatelessWidget {
  final List<GameCard> cards;
  final Function(int) onCardTapped;

  const GridBoard({
    super.key,
    required this.cards,
    required this.onCardTapped,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 80 / 120,
      ),
      itemCount: cards.length,
      itemBuilder: (context, index) {
        return CardWidget(
          isFaceUp: cards[index].isFaceUp,
          onTap: () => onCardTapped(index),
          iconPath: cards[index].iconPath,
        );
      },
    );
  }
}