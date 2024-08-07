import 'dart:async';
import 'package:adphotos/models/ad/ad.dart';
import 'package:adphotos/models/user/user.dart';
import 'package:adphotos/modules/auth/login_screen.dart';
import 'package:adphotos/shared/componants/components.dart';
import 'package:adphotos/shared/constants/constants.dart';
import 'package:adphotos/shared/network/local/remot/cachehelper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'appstatus.dart';
import 'package:firebase_storage/firebase_storage.dart' as firesbase_storage;
import 'package:open_share_pro/open.dart';
class AppBloc extends Cubit<AppState> {
  AppBloc(): super(AppInitState());
  UsersModel? userModel;
  static AppBloc get(context) => BlocProvider.of(context);
  //get ads
   int selectIndex=0;
  late int index;
  //get the Ads into stream builder
  Stream<List<AdModel>> getAds(String catName) {
    return FirebaseFirestore.instance
        .collection('ads')
        .where('catName', isEqualTo:catName)
        .orderBy('startDate',descending: true)
        .snapshots()
        .map((snapshot) {
    return snapshot.docs.map((doc) => AdModel.fromJson(doc.data())).toList();
    });



  }
  // to update likes count
  Future updateLike(AdModel model,String adId) async {
    try {
      await FirebaseFirestore.instance.collection("ads").doc(adId).update(model.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }
  // delete ad
  void deleteAd(String adId, String endDate) async {
    final adsRef = FirebaseFirestore.instance.collection('ads');
    final adDoc = adsRef.doc(adId);
    if (DateTime.now().isAfter(DateTime.parse(endDate))) {
      await adDoc.delete();
    } else {
    }
  }
  // whatsapp
  void launchWhatsApp({required String phone,required String title}) async {
    Open.whatsApp(whatsAppNumber: "$phone", text: "${title}");
  }
  Future signOut({ required BuildContext context})async{
    CacheHelper.removeData(key: 'uId');
    await FirebaseAuth.instance.signOut();
    uId = null;
    navigateAndFinish(context, LoginScreen());
    ;

  }

}
