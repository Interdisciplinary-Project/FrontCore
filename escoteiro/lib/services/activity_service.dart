import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:escoteiro/models/activity_model.dart';

class ActivityService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<ActivityModel>> getActivities() {
    return _firestore
        .collection('activities')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ActivityModel.fromFirestore(doc.data(), doc.id))
          .toList();
    });
  }

  Stream<List<ActivityModel>> getAvailableActivities() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return Stream.value([]);

    return _firestore
        .collection('activities')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .asyncMap((snapshot) async {
      final activities = snapshot.docs
          .map((doc) => ActivityModel.fromFirestore(doc.data(), doc.id))
          .toList();

      final collectedSnapshot = await _firestore
          .collection('user_activities')
          .where('userId', isEqualTo: userId)
          .get();

      final collectedActivityIds = collectedSnapshot.docs
          .map((doc) => doc.data()['activityId'] as String)
          .toSet();

      return activities
          .where((activity) => !collectedActivityIds.contains(activity.id))
          .toList();
    });
  }

  Future<void> createActivity(ActivityModel activity) async {
    await _firestore.collection('activities').add(activity.toFirestore());
  }

  Future<void> updateActivity(String id, ActivityModel activity) async {
    await _firestore.collection('activities').doc(id).update(activity.toFirestore());
    
    final userActivities = await _firestore
        .collection('user_activities')
        .where('activityId', isEqualTo: id)
        .get();
    
    for (var doc in userActivities.docs) {
      await doc.reference.delete();
    }
  }

  Future<void> deleteActivity(String id) async {
    await _firestore.collection('activities').doc(id).delete();
  }

  Future<void> collectActivity(String activityId, int pontos, String activityTitle) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('Usuário não autenticado');

    final existingCollection = await _firestore
        .collection('user_activities')
        .where('userId', isEqualTo: userId)
        .where('activityId', isEqualTo: activityId)
        .get();

    if (existingCollection.docs.isNotEmpty) {
      throw Exception('Atividade já coletada');
    }

    final userDoc = _firestore.collection('users').doc(userId);
    final snapshot = await userDoc.get();
    final currentPoints = snapshot.data()?['pontos'] ?? 0;
    await userDoc.update({'pontos': currentPoints + pontos});

    await _firestore.collection('user_activities').add({
      'userId': userId,
      'activityId': activityId,
      'activityTitle': activityTitle,
      'collectedAt': Timestamp.now(),
    });
  }

  Future<bool> hasCollected(String activityId) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return false;

    final snapshot = await _firestore
        .collection('user_activities')
        .where('userId', isEqualTo: userId)
        .where('activityId', isEqualTo: activityId)
        .get();

    return snapshot.docs.isNotEmpty;
  }
}