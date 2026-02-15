import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  final String id;
  final String title;
  final String imageUrl;
  final String category;
  final String host;
  final String status;
  final bool isPublished;
  final int places;
  final int participantsCount;
  final double price;

  final DateTime dateStart;
  final DateTime? dateEnd;

  final String city;
  final String country;
  final String address;
  final GeoPoint? geo;
  final String locationUrl;

  final List<String> description;
  final List<String> info;
  final List<String> infoImportant;

  final DateTime createdAt;
  final DateTime updatedAt;

  const EventModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.category,
    required this.host,
    required this.status,
    required this.isPublished,
    required this.places,
    required this.participantsCount,
    required this.price,
    required this.dateStart,
    required this.dateEnd,
    required this.city,
    required this.country,
    required this.address,
    required this.geo,
    required this.locationUrl,
    required this.description,
    required this.info,
    required this.infoImportant,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EventModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return EventModel(
      id: doc.id,
      title: (data['title'] ?? '').toString(),
      imageUrl: (data['imageUrl'] ?? '').toString(),
      category: (data['category'] ?? '').toString(),
      host: (data['host'] ?? '').toString(),
      status: (data['status'] ?? 'scheduled').toString(),
      isPublished: data['isPublished'] == true,
      places: _toInt(data['places']),
      participantsCount: _toInt(data['participantsCount']),
      price: _toDouble(data['price']),
      dateStart: _toDate(data['dateStart']),
      dateEnd: _toNullableDate(data['dateEnd']),
      city: (data['city'] ?? '').toString(),
      country: (data['country'] ?? '').toString(),
      address: (data['address'] ?? '').toString(),
      geo: data['geo'] is GeoPoint ? data['geo'] as GeoPoint : null,
      locationUrl: (data['locationUrl'] ?? '').toString(),
      description: _toStringList(data['description']),
      info: _toStringList(data['info']),
      infoImportant: _toStringList(data['infoImportant']),
      createdAt: _toDate(data['createdAt']),
      updatedAt: _toDate(data['updatedAt']),
    );
  }

  static DateTime _toDate(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return DateTime.fromMillisecondsSinceEpoch(0);
  }

  static DateTime? _toNullableDate(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return null;
  }

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return 0;
  }

  static int _toInt(dynamic value) {
    if (value is num) return value.toInt();
    return 0;
  }

  static List<String> _toStringList(dynamic value) {
    if (value is List) {
      return value.map((item) => item.toString()).toList();
    }
    return const [];
  }
}
