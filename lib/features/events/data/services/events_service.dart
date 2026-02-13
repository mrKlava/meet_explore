import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event_model.dart';

class EventsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Fetch all events
  Future<List<EventModel>> fetchEvents() async {
    final snapshot = await _firestore.collection('events').get();
    return snapshot.docs.map((doc) => EventModel.fromFirestore(doc)).toList();
  }

  // Fetch single event
  Future<EventModel?> fetchEventById(String id) async {
    final doc = await _firestore.collection('events').doc(id).get();
    if (!doc.exists) return null;
    return EventModel.fromFirestore(doc);
  }

  // Check if current user participates in an event
  Future<bool> isParticipating(String eventId) async {
    final user = _auth.currentUser;
    if (user == null) return false;

    final doc = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('participations')
        .doc(eventId)
        .get();

    return doc.exists;
  }

  // Participate in an event
  Future<void> participate(String eventId) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('participations')
        .doc(eventId)
        .set({'timestamp': FieldValue.serverTimestamp()});
  }

  // Cancel participation
  Future<void> cancelParticipation(String eventId) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('participations')
        .doc(eventId)
        .delete();
  }

  // Fetch all participating events for current user
  Future<List<String>> fetchParticipatingEventIds() async {
    final user = _auth.currentUser;
    if (user == null) return [];

    final snapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('participations')
        .get();

    return snapshot.docs.map((doc) => doc.id).toList();
  }
}
