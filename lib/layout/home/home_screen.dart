import 'package:adphotos/core/componants/components.dart';
import 'package:adphotos/core/network/local/remot/cachehelper.dart';
import 'package:adphotos/core/strings/constants.dart';
import 'package:adphotos/features/Ads/data/models/ad.dart';
import 'package:adphotos/features/Ads/presention/bloc/ad_bloc.dart';
import 'package:adphotos/features/Ads/presention/pages/ads_screen.dart';
import 'package:adphotos/features/ads/domain/entities/ad.dart';
import 'package:adphotos/features/ads/presention/pages/details_screen.dart';
import 'package:adphotos/features/auth/presention/pages/login_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:open_share_plus/open.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class HomePage extends StatelessWidget {
   HomePage({Key? key}) : super(key: key);
   int index=0;
  @override
  Widget build(BuildContext context) {
      return BlocConsumer<AdBloc, AdState>(
        listener: (context, state) {},
        builder: (context, state) {
          AdBloc bloc= BlocProvider.of<AdBloc>(context);
          FirebaseMessaging.onMessageOpenedApp.listen((event) {
            if(event.data!=null){
              if(CacheHelper.getData(key:'uId')!=null) {
                navigateTo(context, HomePage());
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
                        '${bloc.currentUser?.username}',
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
                      Open.whatsApp(whatsAppNumber: "+963991789422", text: "Hey i need to share an Ad in your App");
                    },
                  ),
                  ListTile(
                    title: Row(children: [
                      Text('Restart app'),
                      Spacer(),
                      Icon(Icons.restart_alt),
                    ],),
                    onTap: () {
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
                              await CacheHelper.removeData(key: 'uId');
                              await FirebaseAuth.instance.signOut();
                              uId = null;
                              navigateAndFinish(context, LoginPage());
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
                          List<Ad> ads = snapshot.data!.docs.map((doc) => AdModel.fromJson(doc.data())).toList();
                          List <String>imageUrls = snapshot.data!.docs.map((
                              doc) => doc['image']).cast<String>().toList();
                          return Center();
                        }
                    }),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0,top: 8.0,bottom: 8.0),
                  child: Text('Categories',style: TextStyle(color: Colors.black),),
                ),
                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('ads')
                        .where('vip', isEqualTo: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      if (!snapshot.hasData) {
                        return Text('No data available');
                      } else {
                        List<Ad> ads = snapshot.data!.docs
                            .map((doc) => AdModel.fromJson(doc.data()))
                            .toList();
                        List<String> imageUrls = snapshot.data!.docs
                            .map((doc) => doc['image'] as String)
                            .toList();
                        // return buildSlider(imageUrls, context, ads);
                        return Center();
                      }
                    },
                  )              ],
            ),
          ),
                    );
      },
    );
  }
}
Widget buildGrid(AdBloc cubit,int index,BuildContext context,List titles,List image)=>
           Column(children: [
        InkWell(
          onTap: (){
             index=index;
            navigateTo(context, AdsPage(index:index,catName: titles[index],));},
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
            index=index;
            navigateTo(context, AdsPage(index: index,catName: titles[index],));},
          child: Container(
             width: MediaQuery.of(context).size.width/2.150,
              decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.only(bottomLeft:Radius.circular(15),bottomRight:Radius.circular(15) )),
              child: Center(child: Text(titles[index]))),
        ),
      ]);

Widget buildSlider(List<String>imageUrls,BuildContext context,List<Ad>ads,)=>
    CarouselSlider(
  items: imageUrls.asMap().entries.map((entry) {
    int index = entry.key;
    String url = entry.value;
    return GestureDetector(
      onTap: () {
        navigateTo(context, DetailsPage(ads[index]));
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
