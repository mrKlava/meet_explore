import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/event_model.dart';
import '../../domain/entities/event.dart';

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

  Future<List<EventModel>> fetchAllEventsForAdmin() async {
    final snapshot = await _firestore
        .collection('events')
        .orderBy('dateStart', descending: true)
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

    final eventRef = _firestore.collection('events').doc(eventId);
    final userParticipationRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('participations')
        .doc(eventId);
    final eventParticipantRef =
        eventRef.collection('participants').doc(user.uid);

    await _firestore.runTransaction((tx) async {
      final eventSnap = await tx.get(eventRef);
      if (!eventSnap.exists) {
        throw Exception('Event not found');
      }

      final userParticipationSnap = await tx.get(userParticipationRef);
      final eventParticipantSnap = await tx.get(eventParticipantRef);
      if (userParticipationSnap.exists || eventParticipantSnap.exists) {
        return;
      }

      final data = eventSnap.data() ?? <String, dynamic>{};
      final places = (data['places'] as num?)?.toInt() ?? 0;
      final participantsCount =
          (data['participantsCount'] as num?)?.toInt() ?? 0;

      final hasLimitedPlaces = places > 0;
      if (hasLimitedPlaces && participantsCount >= places) {
        throw Exception('No places left');
      }

      final timestamp = FieldValue.serverTimestamp();
      tx.set(userParticipationRef, {'timestamp': timestamp});
      tx.set(eventParticipantRef, {'timestamp': timestamp});

      if (hasLimitedPlaces) {
        tx.update(eventRef, {'participantsCount': participantsCount + 1});
      }
    });
  }

  Future<void> cancelParticipation(String eventId) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    final eventRef = _firestore.collection('events').doc(eventId);
    final userParticipationRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('participations')
        .doc(eventId);
    final eventParticipantRef =
        eventRef.collection('participants').doc(user.uid);

    await _firestore.runTransaction((tx) async {
      final eventSnap = await tx.get(eventRef);
      if (!eventSnap.exists) {
        return;
      }

      final userParticipationSnap = await tx.get(userParticipationRef);
      final eventParticipantSnap = await tx.get(eventParticipantRef);
      if (!userParticipationSnap.exists && !eventParticipantSnap.exists) {
        return;
      }

      if (userParticipationSnap.exists) {
        tx.delete(userParticipationRef);
      }
      if (eventParticipantSnap.exists) {
        tx.delete(eventParticipantRef);
      }

      final data = eventSnap.data() ?? <String, dynamic>{};
      final places = (data['places'] as num?)?.toInt() ?? 0;
      final participantsCount =
          (data['participantsCount'] as num?)?.toInt() ?? 0;
      final hasLimitedPlaces = places > 0;

      if (hasLimitedPlaces) {
        final nextCount = participantsCount > 0 ? participantsCount - 1 : 0;
        tx.update(eventRef, {'participantsCount': nextCount});
      }
    });
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

  Future<void> updateEventPublishStatus({
    required String eventId,
    required bool isPublished,
  }) async {
    await _firestore.collection('events').doc(eventId).update({
      'isPublished': isPublished,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateEventStatus({
    required String eventId,
    required String status,
  }) async {
    await _firestore.collection('events').doc(eventId).update({
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> createEvent(Event event) async {
    final docRef = _firestore.collection('events').doc();
    await docRef.set(_eventToFirestoreMap(event, includeCreatedAt: true));
  }

  Future<void> updateEvent(Event event) async {
    await _firestore
        .collection('events')
        .doc(event.id)
        .update(_eventToFirestoreMap(event, includeCreatedAt: false));
  }

  Future<void> deleteEvent(String eventId) async {
    await _firestore.collection('events').doc(eventId).delete();
  }

  Map<String, dynamic> _eventToFirestoreMap(
    Event event, {
    required bool includeCreatedAt,
  }) {
    final map = <String, dynamic>{
      'title': event.title,
      'imageUrl': event.imageUrl,
      'category': event.category,
      'host': event.host,
      'status': event.status,
      'isPublished': event.isPublished,
      'places': event.places,
      'price': event.price,
      'dateStart': Timestamp.fromDate(event.dateStart),
      'dateEnd':
          event.dateEnd != null ? Timestamp.fromDate(event.dateEnd!) : null,
      'city': event.city,
      'country': event.country,
      'address': event.address,
      'geo': (event.geoLat != null && event.geoLng != null)
          ? GeoPoint(event.geoLat!, event.geoLng!)
          : null,
      'locationUrl': event.locationUrl,
      'description': event.description,
      'info': event.info,
      'infoImportant': event.infoImportant,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (includeCreatedAt) {
      map['participantsCount'] = 0;
      map['createdAt'] = FieldValue.serverTimestamp();
    }
    return map;
  }
}
