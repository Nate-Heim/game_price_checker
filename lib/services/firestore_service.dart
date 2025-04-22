import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  static final _db = FirebaseFirestore.instance;

  static Future<void> addToWishlist(String title, String price) {
    return _db.collection('wishlist').add({
      'title': title,
      'price': price,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  static Stream<QuerySnapshot> getWishlist() {
    return _db.collection('wishlist').orderBy('timestamp', descending: true).snapshots();
  }
}
