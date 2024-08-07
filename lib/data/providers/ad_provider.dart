import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:adphotos/models/ad/ad.dart';

class AdProvider {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get ads by category name
  Stream<List<AdModel>> getAds(String catName) {
    return _firestore
        .collection('ads')
        .where('catName', isEqualTo: catName)
        .orderBy('startDate', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => AdModel.fromJson(doc.data())).toList();
    });
  }

  // Update like count for an ad
  Future<void> updateLike(AdModel model, String adId) async {
    await _firestore.collection("ads").doc(adId).update(model.toMap());
  }

  // Delete an ad
  Future<void> deleteAd(String adId, String endDate) async {
    final adsRef = _firestore.collection('ads');
    final adDoc = adsRef.doc(adId);
    if (DateTime.now().isAfter(DateTime.parse(endDate))) {
      await adDoc.delete();
    }
  }
}
