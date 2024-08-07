import 'dart:async';
import 'package:adphotos/data/services/ad_service.dart';
import 'package:adphotos/models/ad/ad.dart';
import 'package:adphotos/models/user/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'appstatus.dart';
import 'package:open_share_pro/open.dart';

class AppBloc extends Cubit<AppState> {
  final AdService _adService;

  AppBloc(this._adService) : super(AppInitState());

  UsersModel? userModel;
  static AppBloc get(context) => BlocProvider.of(context);

  int selectIndex = 0;
  late int index;

  Stream<List<AdModel>> getAds(String catName) {
    return _adService.getAds(catName);
  }

  Future<void> updateLike(AdModel model, String adId) async {
    try {
      // Use AdService to update like count and return the result
       await _adService.updateLike(model, adId);
    } catch (e) {
    }
  }


  void deleteAd(String adId, String endDate) {
    _adService.deleteAd(adId, endDate);
  }

  void launchWhatsApp({required String phone, required String title}) async {
    Open.whatsApp(whatsAppNumber: phone, text: title);
  }
}
