import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/event_model.dart';

class EventsRemoteService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  EventsRemoteService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  Future<List<EventModel>> fetchEvents() async {
    final snapshot = await _firestore
        .collection('events')
        .where('isPublished', isEqualTo: true)
        .orderBy('dateStart')
        .get();

    return snapshot.docs.map((doc) => EventModel.fromFirestore(doc)).toList();
  }

  Future<EventModel?> fetchEventById(String id) async {
    final doc = await _firestore.collection('events').doc(id).get();
    if (!doc.exists) return null;
    return EventModel.fromFirestore(doc);
  }

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
