import '../models/event_model.dart';

class EventsService {
  final List<EventModel> _events = [
  EventModel(
    id: 1,
    imageUrl: 'https://picsum.photos/400/200?1',
    title: 'Meet & Explore Pau',
    description: 'Casual meetup to explore the city and meet new people.',
    detailedDescription:
        'Join us for a walking tour around Pau! We will explore the city center, historic sites, and local cafes. Great opportunity to meet locals and travelers alike. Wear comfortable shoes!',
    dateTime: DateTime(2026, 2, 10, 18, 30),
    location: 'Pau, France',
    host: 'Alice Dupont',
    category: 'City Tour',
    price: 0.0,
    isParticipating: true
  ),
  EventModel(
    id: 2,
    imageUrl: 'https://picsum.photos/400/200?2',
    title: 'Bowling Night',
    description: 'Fun evening of bowling and snacks.',
    detailedDescription:
        'Come to Strike Bowling Center for a friendly competition! Shoes, lanes, and snacks are included. Bring your friends or meet new people!',
    dateTime: DateTime(2026, 2, 11, 20, 0),
    location: 'Billère, near Pau',
    host: 'Jean Martin',
    category: 'Recreation',
    price: 10.0,
  ),
  EventModel(
    id: 3,
    imageUrl: 'https://picsum.photos/400/200?3',
    title: 'Theater Evening',
    description: 'Watch a local play with fellow theater lovers.',
    detailedDescription:
        'Enjoy a local performance at Théâtre de Pau. Engage with actors after the show in Q&A. Seats are limited!',
    dateTime: DateTime(2026, 2, 12, 19, 30),
    location: 'Pau, France',
    host: 'Marie Lefevre',
    category: 'Theater',
    price: 15.0,
  ),
  EventModel(
    id: 4,
    imageUrl: 'https://picsum.photos/400/200?4',
    title: 'Coffee & Chat',
    description: 'Casual meetup at a local café.',
    detailedDescription:
        'Relax and have coffee with other attendees. Discuss hobbies, ideas, and networking. First drink is on us!',
    dateTime: DateTime(2026, 2, 13, 17, 0),
    location: 'Lons, near Pau',
    host: 'Luc Bernard',
    category: 'Networking',
    price: 5.0,
  ),
  EventModel(
    id: 5,
    imageUrl: 'https://picsum.photos/400/200?5',
    title: 'Cooking Workshop',
    description: 'Learn to cook a traditional French dish.',
    detailedDescription:
        'Chef-led workshop teaching a classic French recipe. Ingredients and utensils provided. Enjoy your creation at the end!',
    dateTime: DateTime(2026, 2, 14, 18, 0),
    location: 'Pau, France',
    host: 'Chef Sophie',
    category: 'Workshop',
    price: 20.0,
  ),
  EventModel(
    id: 6,
    imageUrl: 'https://picsum.photos/400/200?6',
    title: 'Restaurant Meetup',
    description: 'Dinner gathering at a cozy local restaurant.',
    detailedDescription:
        'Join us for a social dinner at Le Petit Bistrot. Enjoy French cuisine and meet new people. Optional drinks available.',
    dateTime: DateTime(2026, 2, 15, 19, 30),
    location: 'Idron, near Pau',
    host: 'Marc Dupuis',
    category: 'Dining',
    price: 25.0,
  ),
  EventModel(
    id: 7,
    imageUrl: 'https://picsum.photos/400/200?7',
    title: 'Board Games Night',
    description: 'Play board games with fellow enthusiasts.',
    detailedDescription:
        'Board games night at Café Ludique. Bring your favorite game or play one of ours. Snacks and drinks available.',
    dateTime: DateTime(2026, 2, 16, 18, 30),
    location: 'Pau, France',
    host: 'Clara Roche',
    category: 'Recreation',
    price: 5.0,
    isParticipating: true
  ),
  EventModel(
    id: 8,
    imageUrl: 'https://picsum.photos/400/200?8',
    title: 'Hiking Meetup',
    description: 'Short hike with group discussion breaks.',
    detailedDescription:
        'Explore scenic trails around Bizanos. Moderate difficulty hike. Bring comfortable shoes, water, and snacks. Great for outdoor enthusiasts!',
    dateTime: DateTime(2026, 2, 17, 9, 0),
    location: 'Bizanos, near Pau',
    host: 'Julien Moreau',
    category: 'Outdoor',
    price: 0.0,
  ),
  EventModel(
    id: 9,
    imageUrl: 'https://picsum.photos/400/200?9',
    title: 'Local Music Night',
    description: 'Enjoy live music at a local bar.',
    detailedDescription:
        'Live band performing jazz and blues at Bar du Centre. Drinks and snacks available. Meet music lovers in a relaxed environment.',
    dateTime: DateTime(2026, 2, 18, 20, 0),
    location: 'Pau, France',
    host: 'Thomas Blanc',
    category: 'Music',
    price: 8.0,
  ),
  EventModel(
    id: 10,
    imageUrl: 'https://picsum.photos/400/200?10',
    title: 'Art & Wine Evening',
    description: 'Painting workshop paired with wine tasting.',
    detailedDescription:
        'Create your own painting under the guidance of a local artist. Taste local wines while painting. Materials and first glass included.',
    dateTime: DateTime(2026, 2, 19, 18, 30),
    location: 'Lée, near Pau',
    host: 'Isabelle Font',
    category: 'Workshop',
    price: 30.0,
  ),
];


  // Simulate API call
  Future<List<EventModel>> fetchEvents() async {
    await Future.delayed(const Duration(seconds: 1)); // fake network delay

    return _events;
  }

  Future<List<EventModel>> fetchParticipatingEvents() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _events.where((event) => event.isParticipating).toList();
  }

  // Fetch single event by id
  Future<EventModel?> fetchEventById(int id) async {
    await Future.delayed(
      const Duration(milliseconds: 500),
    ); // simulate network delay
    try {
      return _events.firstWhere((event) => event.id == id);
    } catch (e) {
      return null; // safe null if not found
    }
  }
}
