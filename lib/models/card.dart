class Card {
  final String id;
  final String iconName; 
  bool isMatched;        
  bool isFaceUp;         

  Card({
    required this.id,
    required this.iconName,
    this.isMatched = false,
    this.isFaceUp = false,
  });
}