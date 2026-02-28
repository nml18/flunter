import 'package:flunter/constants/icon_categories.dart';
import 'package:flunter/constants/icon_colors.dart';
import 'package:flunter/models/game_card.dart';
import 'dart:math';

enum Difficulties{easy, medium, hard}
enum GameStatus{waiting, oneCardTapped, comparing, won}

class Game{
  List<GameCard> cards = [];
  final Difficulties difficulty;
  GameStatus status = GameStatus.waiting;
  int attempts = 0;
  int? firstTappedIndex, secondTappedIndex;

  Game({
    required this.difficulty,
  }){
    initGame(difficulty);
  }
  
  void initGame(Difficulties difficulty){
    return switch (difficulty){
      Difficulties.easy => initCards(4),
      Difficulties.medium => initCards(8),
      Difficulties.hard => initCards(12),
    };
  }

  void initCards(int pairOfCards){
    final String iconCategory = iconCategories[Random().nextInt(iconCategories.length)];
    for (int i = 0; i < pairOfCards; i++){
      String iconColor = iconColors[i];
      for (int j = 0; j < 2; j++){
        cards.add(GameCard(
          id: '${iconColor}_$j',
          iconPath: 'icons/$iconCategory/$iconColor.svg',
        ));
      }
    }
    shuffleCards();
  }

  void shuffleCards(){
    cards.shuffle();
    firstTappedIndex = null;
    secondTappedIndex = null;
    status = GameStatus.waiting;
  }

  void onCardTapped(int index, Function onAfterDelay){
    GameCard tappedCard = cards[index];
    if (tappedCard.isFaceUp) return;
    if (status == GameStatus.comparing) return;
    if (status == GameStatus.won) return;
    if (index == firstTappedIndex) return;
    tappedCard.isFaceUp = true;

    switch (status){
      case GameStatus.waiting:
        firstTappedIndex = index;
        status = GameStatus.oneCardTapped;
        break;

      case GameStatus.oneCardTapped:
        secondTappedIndex = index;
        status = GameStatus.comparing;
        checkMatchingPair(onAfterDelay);
        break;

      default:
        break;
    }
  }

  void checkMatchingPair(Function onUpdate){
    attempts++;
    GameCard firstTappedCard = cards[firstTappedIndex!];
    GameCard secondTappedCard = cards[secondTappedIndex!];

    if (firstTappedCard.iconPath == secondTappedCard.iconPath){
      firstTappedCard.isMatched = true;
      secondTappedCard.isMatched = true;
      firstTappedIndex = null;
      secondTappedIndex = null;
      isGameOver() ? status = GameStatus.won : status = GameStatus.waiting;
    }
    else{
      Future.delayed(const Duration(seconds: 1), () {
        firstTappedCard.isFaceUp = false;
        secondTappedCard.isFaceUp = false;
        firstTappedIndex = null;
        secondTappedIndex = null;
        status = GameStatus.waiting;
        onUpdate();
      });
    }
  }

  void resetGame(){
    for (GameCard card in cards){
      card.isFaceUp = false;
      card.isMatched = false;
    }
    attempts = 0;
    shuffleCards();
  }

  bool isGameOver() => cards.every((card) => card.isMatched);
}
