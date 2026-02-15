class Event {
  final String id;
  final String title;
  final String imageUrl;
  final String category;
  final String host;
  final String status;
  final bool isPublished;
  final int places;
  final double price;

  final DateTime dateStart;
  final DateTime? dateEnd;

  final String city;
  final String country;
  final String address;
  final double? geoLat;
  final double? geoLng;
  final String locationUrl;

  final List<String> description;
  final List<String> info;
  final List<String> infoImportant;

  final DateTime createdAt;
  final DateTime updatedAt;

  const Event({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.category,
    required this.host,
    required this.status,
    required this.isPublished,
    required this.places,
    required this.price,
    required this.dateStart,
    required this.dateEnd,
    required this.city,
    required this.country,
    required this.address,
    required this.geoLat,
    required this.geoLng,
    required this.locationUrl,
    required this.description,
    required this.info,
    required this.infoImportant,
    required this.createdAt,
    required this.updatedAt,
  });

  String get shortLocation {
    if (city.isNotEmpty && country.isNotEmpty) return '$city, $country';
    if (city.isNotEmpty) return city;
    if (country.isNotEmpty) return country;
    return address;
  }

  String get fullLocation {
    if (address.isNotEmpty && shortLocation.isNotEmpty) {
      return '$address, $shortLocation';
    }
    return address.isNotEmpty ? address : shortLocation;
  }

  String get descriptionText => description.join('\n');
}
