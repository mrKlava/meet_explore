class EventModel {
  final int id;
  final String imageUrl;
  final String title;
  final String description; // short description
  final String detailedDescription; // long description
  final DateTime dateTime;
  final String location;
  final String host; // who organizes it
  final String category; // type: theater, bowling, etc
  final double price; // optional, 0 = free
  bool isParticipating;

  EventModel({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.detailedDescription,
    required this.dateTime,
    required this.location,
    required this.host,
    required this.category,
    this.price = 0.0,
    this.isParticipating = false,
  });
}
