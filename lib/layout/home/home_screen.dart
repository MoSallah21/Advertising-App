import 'dart:async';

import 'package:adphotos/models/ad/ad.dart';
import 'package:adphotos/modules/ads/ads_screen.dart';
import 'package:adphotos/modules/auth/login_screen.dart';
import 'package:adphotos/modules/detalis/details_screen.dart';
import 'package:adphotos/shared/bloc/app/appbloc.dart';
import 'package:adphotos/shared/bloc/app/appstatus.dart';
import 'package:adphotos/shared/componants/components.dart';
import 'package:adphotos/shared/constants/constants.dart';
import 'package:adphotos/shared/network/local/remot/cachehelper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:restart_app/restart_app.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class HomeScreen extends StatelessWidget {
   HomeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Future<void> Subscribe() async {
      await FirebaseMessaging.instance.subscribeToTopic('/topics/app');
    }
      return BlocConsumer<AppBloc, AppState>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit=AppBloc.get(context);
          Subscribe();
          FirebaseMessaging.onMessage.listen((RemoteMessage message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('New ad added',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                backgroundColor: Colors.blue,
              ),
            );
          });
          FirebaseMessaging.onMessageOpenedApp.listen((event) {
            if(event.data!=null){
              if(CacheHelper.getData(key:'uId')!=null) {
                navigateTo(context, HomeScreen());
              }
            }
          });
          return Scaffold(
            appBar: AppBar(
              backgroundColor: HexColor('#5A5A5A'),
              centerTitle: true,
              actions: [
                Icon(Icons.home_filled,color: Colors.white,),
                SizedBox(width: 10,),
              ],
              title: Text('Home',style: TextStyle(color: Colors.white),),
            ),
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/image/gray.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '${cubit.userModel?.username}',
                        style: TextStyle(color: Colors.black,fontSize: 24,fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                  ListTile(
                    title: Row(children: [
                      Text('Advertisement'),
                      Spacer(),
                      Icon(Icons.public),
                    ],),
                    onTap: () {
                      cubit.launchWhatsApp(phone: '+963941899671',title: 'Hello, I want to post a new ad.');
                    },
                  ),
                  ListTile(
                    title: Row(children: [
                      Text('Restart app'),
                      Spacer(),
                      Icon(Icons.restart_alt),
                    ],),
                    onTap: () {
                      Restart.restartApp();
                    },
                  ),
                  ListTile(
                    title: Row(children: [
                      Text('Sign out'),
                      Spacer(),
                      Icon(Icons.logout),
                    ],),
                    onTap: () async{
                      Alert(
                        context: context,
                        type: AlertType.warning,
                        desc: "Are you sure ?",
                        buttons: [
                          DialogButton(
                            child: Text(
                              "Yes",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 20),
                            ),
                            onPressed: () async {
                              await cubit.signOut(context: context);

                            },
                            width: 120,
                            color: Colors.grey,
                          ),
                          DialogButton(
                            child: Text(
                              "No",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 20),
                            ),
                            onPressed: () => Navigator.pop(context),
                            width: 120,
                            color: Colors.grey,
                          ),
                        ],
                      ).show();
                    },
                  ),
                ],
              ),
            ),
            body: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/image/gray.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance.collection('ads') .where('vip', isEqualTo:true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }
                        if (!snapshot.hasData) {
                          return Text('No data available');
                        }else {
                          List<AdModel> ads = snapshot.data!.docs.map((doc) => AdModel.fromJson(doc.data())).toList();
                          List <String>imageUrls = snapshot.data!.docs.map((
                              doc) => doc['image']).cast<String>().toList();
                          return buildSlider(imageUrls,context,ads);
                        }
                    }),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0,top: 8.0,bottom: 8.0),
                  child: Text('Categories',style: TextStyle(color: Colors.black),),
                ),
              StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('categories').orderBy('categoryId', descending: false).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (!snapshot.hasData) {
                  return Text('No data available');
                }
                List<DocumentSnapshot> documents = snapshot.data!.docs;
                List titles = documents.map((doc) => doc['title']).toList();
                List image = documents.map((doc) => doc['image']).toList();
                return Expanded(child: GridView.count(crossAxisCount: 2,
                  children: List.generate(
                      titles.length, (index) {
                    return buildGrid(cubit, index, context,titles,image);
                  }),
                  shrinkWrap: false,
                  physics: BouncingScrollPhysics(),));
              })
              ],
            ),
          ),
                    );
      },
    );
  }
}
Widget buildGrid(AppBloc cubit,int index,BuildContext context,List titles,List image)=>
           Column(children: [
        InkWell(
          onTap: (){
            cubit.index=index;
            navigateTo(context, AdsScreen(index: cubit.index,catName: titles[index],));},
          child: Container(
            height: MediaQuery.of(context).size.height/5.4,
            width: MediaQuery.of(context).size.width/2.150,
            decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.only(topLeft:Radius.circular(15),topRight:Radius.circular(15) )),
            child:CachedNetworkImage(
              imageUrl: image[index],
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
        ),
        InkWell(
          onTap: (){
            cubit.index=index;
            navigateTo(context, AdsScreen(index: cubit.index,catName: titles[index],));},
          child: Container(
             width: MediaQuery.of(context).size.width/2.150,
              decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.only(bottomLeft:Radius.circular(15),bottomRight:Radius.circular(15) )),
              child: Center(child: Text(titles[index]))),
        ),
      ]);

Widget buildSlider(List<String>imageUrls,BuildContext context,List<AdModel>ads,)=>
    CarouselSlider(
  items: imageUrls.asMap().entries.map((entry) {
    int index = entry.key;
    String url = entry.value;
    return GestureDetector(
      onTap: () {
        navigateTo(context, DetailsScreen(ads[index]));
      },
      child: Image(
        fit: BoxFit.fitWidth,
        width: double.infinity,
        image: NetworkImage(url),),
    );
  }).toList(),
  options: CarouselOptions(
    autoPlay: true,
    initialPage: 0,
    reverse: false,
    viewportFraction: 1,
    scrollDirection: Axis.horizontal,
    autoPlayCurve: Curves.fastOutSlowIn,
    autoPlayInterval: Duration(seconds: 15),
    autoPlayAnimationDuration: Duration(seconds: 2),
    enlargeCenterPage: true,
  ),
);
