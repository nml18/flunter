class CardModel {
  final String id;
  final String iconName; 
  bool isMatched;        
  bool isFaceUp;         

  CardModel({
    required this.id,
    required this.iconName,
    this.isMatched = false,
    this.isFaceUp = false,
  });
}