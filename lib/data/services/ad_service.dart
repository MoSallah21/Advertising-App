import 'package:adphotos/data/repositories/ad_repository.dart';
import 'package:adphotos/models/ad/ad.dart';

class AdService {
  final AdRepository _adRepository;

  AdService(this._adRepository);

  // Get ads by category name
  Stream<List<AdModel>> getAds(String catName) {
    return _adRepository.getAds(catName);
  }

  // Update like count for an ad
  Future<void> updateLike(AdModel model, String adId) {
    return _adRepository.updateLike(model, adId);
  }

  // Delete an ad
  Future<void> deleteAd(String adId, String endDate) {
    return _adRepository.deleteAd(adId, endDate);
  }
}
