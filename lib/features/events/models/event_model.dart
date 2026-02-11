import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  final String id;
  final String title;
  final String host;
  final String category;
  final String location;
  final String imageUrl;
  final double price;
  final String detailedDescription;
  final DateTime dateTime;

  bool isParticipating;

  EventModel({
    required this.id,
    required this.title,
    required this.host,
    required this.category,
    required this.location,
    required this.imageUrl,
    required this.price,
    required this.detailedDescription,
    required this.dateTime,
    this.isParticipating = false,
  });

  factory EventModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return EventModel(
      id: doc.id,
      title: data['title'] ?? '',
      host: data['host'] ?? '',
      category: data['category'] ?? '',
      location: data['location'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      detailedDescription: data['detailedDescription'] ?? '',
      dateTime: (data['dateTime'] as Timestamp).toDate(),
    );
  }
}
