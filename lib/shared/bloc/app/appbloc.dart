import 'dart:async';
import 'package:adphotos/data/repositories/ad_repository.dart';
import 'package:adphotos/models/ad/ad.dart';
import 'package:adphotos/models/user/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'appstatus.dart';
import 'package:open_share_pro/open.dart';

class AppBloc extends Cubit<AppState> {
  final AdRepository _adRepository;

  AppBloc(this._adRepository) : super(AppInitState());

  UsersModel? userModel;
  static AppBloc get(context) => BlocProvider.of(context);

  int selectIndex = 0;
  late int index;

  Stream<List<AdModel>> getAds(String catName) {
    return _adRepository.getAds(catName);
  }

  Future<void> updateLike(AdModel model, String adId) async {
    bool success = await _adRepository.updateLike(model, adId);
    if (success) {
      // handle success
    } else {
      // handle failure
    }
  }

  void deleteAd(String adId, String endDate) {
    _adRepository.deleteAd(adId, endDate);
  }

  void launchWhatsApp({required String phone, required String title}) async {
    Open.whatsApp(whatsAppNumber: phone, text: title);
  }
}
