import 'package:flunter/constants/icon_colors.dart';
import 'package:flunter/models/card.dart';

enum Difficulties{easy, medium, hard}
enum GameStatus{waiting, oneCardTapped, comparing, won}

class Game{
  List<Card> cards = [];
  Difficulties difficulty;
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
    for (int i = 0; i < pairOfCards; i++){
      String iconColor = iconColors[i];
      for (int j = 0; j < 2; j++){
        cards.add(Card(
          id: '${iconColor}_$j',
          iconName: iconColor,
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

  void onCardTapped(int index){
    Card tappedCard = cards[index];
    if (tappedCard.isFaceUp) return;
    if (status == GameStatus.comparing) return;
    if (status == GameStatus.won) return;
    if (index == firstTappedIndex) return;

    switch (status){
      case GameStatus.waiting:
        tappedCard.isFaceUp = true;
        firstTappedIndex = index;
        status = GameStatus.oneCardTapped;
        break;

      case GameStatus.oneCardTapped:
        tappedCard.isFaceUp = true;
        secondTappedIndex = index;
        status = GameStatus.comparing;

        checkMatchingPair();
        break;

      default:
        break;
    }
  }

  void checkMatchingPair(){
    attempts++;
    Card firstTappedCard = cards[firstTappedIndex!];
    Card secondTappedCard = cards[secondTappedIndex!];

    if (firstTappedCard.iconName == secondTappedCard.iconName){
      firstTappedCard.isMatched = true;
      secondTappedCard.isMatched = true;
      firstTappedIndex = null;
      secondTappedIndex = null;
      isGameOver() ? status = GameStatus.won : status = GameStatus.waiting;
    }
    else{
      Future.delayed(const Duration(milliseconds: 500), () {
        firstTappedCard.isFaceUp = false;
        secondTappedCard.isFaceUp = false;
        firstTappedIndex = null;
        secondTappedIndex = null;
        status = GameStatus.waiting;
      });
    }
  }

  void resetGame(){
    for (Card card in cards){
      card.isFaceUp = false;
      card.isMatched = false;
    }
    attempts = 0;
    shuffleCards();
  }

  bool isGameOver() => cards.every((card) => card.isMatched);
}
