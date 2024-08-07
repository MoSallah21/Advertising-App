import 'package:adphotos/models/ad/ad.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  Future<bool> updateLike(AdModel model, String adId) async {
    try {
      await _firestore.collection("ads").doc(adId).update(model.toMap());
      return true;
    } catch (e) {
      // Handle error
      return false;
    }
  }

  Future<void> deleteAd(String adId, String endDate) async {
    try {
      final adsRef = _firestore.collection('ads');
      final adDoc = adsRef.doc(adId);
      if (DateTime.now().isAfter(DateTime.parse(endDate))) {
        await adDoc.delete();
      }
    } catch (e) {
      // Handle error
    }
  }
}
