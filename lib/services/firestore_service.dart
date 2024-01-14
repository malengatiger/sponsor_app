import 'package:cloud_firestore/cloud_firestore.dart';

import '../data/gemini_response_rating.dart';
class FirestoreService {
  final FirebaseFirestore firebaseFirestore;

  FirestoreService(this.firebaseFirestore) {
    firebaseFirestore.settings = const Settings(
      persistenceEnabled: true,
    );
  }

  Future<List<GeminiResponseRating>> getRatings(int examLinkId) async {
    List<GeminiResponseRating> ratings = [];
    var querySnapshot =
    await firebaseFirestore.collection('GeminiResponseRating')
        .where('examLinkId', isEqualTo: examLinkId)
        .get();
    for (var s in querySnapshot.docs) {
      var rating = GeminiResponseRating.fromJson(s.data());
      ratings.add(rating);
    }
    return ratings;
  }
  Future addRating(GeminiResponseRating rating) async {
    var colRef = firebaseFirestore.collection('GeminiResponseRating');
    await colRef.add(rating.toJson());
  }
}
