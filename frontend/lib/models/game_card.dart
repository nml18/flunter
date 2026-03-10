class GameCard {
  final String id;
  final String iconPath; 
  bool isMatched;        
  bool isFaceUp;         

  GameCard({
    required this.id,
    required this.iconPath,
    this.isMatched = false,
    this.isFaceUp = false,
  });
}