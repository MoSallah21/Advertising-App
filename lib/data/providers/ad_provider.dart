import 'package:adphotos/data/repositories/ad_repository.dart';
import 'package:adphotos/models/ad/ad.dart';

class AdProvider {
  final AdRepository _repository;

  AdProvider(this._repository);

  Stream<List<AdModel>> getAds(String catName) {
    return _repository.getAds(catName);
  }

  Future<bool> updateLike(AdModel model, String adId) {
    return _repository.updateLike(model, adId);
  }

  Future<void> deleteAd(String adId, String endDate) {
    return _repository.deleteAd(adId, endDate);
  }
}
