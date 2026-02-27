class GameCard {
  final String id;
  final String iconName; 
  bool isMatched;        
  bool isFaceUp;         

  GameCard({
    required this.id,
    required this.iconName,
    this.isMatched = false,
    this.isFaceUp = false,
  });
}