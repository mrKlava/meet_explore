class Event {
  final String id;
  final String title;
  final String host;
  final String category;
  final String location;
  final String imageUrl;
  final double price;
  final String detailedDescription;
  final DateTime dateTime;

  const Event({
    required this.id,
    required this.title,
    required this.host,
    required this.category,
    required this.location,
    required this.imageUrl,
    required this.price,
    required this.detailedDescription,
    required this.dateTime,
  });
}
