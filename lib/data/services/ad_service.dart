import 'package:adphotos/data/providers/ad_provider.dart';
import 'package:adphotos/models/ad/ad.dart';

class AdService {
  final AdProvider _adProvider;

  AdService(this._adProvider);

  // Get ads by category name
  Stream<List<AdModel>> getAds(String catName) {
    return _adProvider.getAds(catName);
  }

  // Update like count for an ad
  Future<void> updateLike(AdModel model, String adId) {
    return _adProvider.updateLike(model, adId);
  }

  // Delete an ad
  Future<void> deleteAd(String adId, String endDate) {
    return _adProvider.deleteAd(adId, endDate);
  }
}
