import 'package:adphotos/models/ad/ad.dart';
import 'package:adphotos/modules/detalis/details_screen.dart';
import 'package:adphotos/shared/bloc/app/appbloc.dart';
import 'package:adphotos/shared/bloc/app/appstatus.dart';
import 'package:adphotos/shared/componants/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:iconly/iconly.dart';
import 'package:pull_down_button/pull_down_button.dart';

class AdsScreen extends StatelessWidget {
  int index;
  String catName;
  AdsScreen({required this.index,required this.catName});

  Color likeColor=Colors.white;
  IconData likeIcon=IconlyLight.heart;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppBloc,AppState>(
      listener: (context, state) {
      },
      builder: (context, state)  {
        var cubit =AppBloc.get(context);
        return Scaffold(
          backgroundColor: HexColor('#5A5A5A'), // s
          appBar: AppBar(
            backgroundColor: HexColor('#5A5A5A'),
            elevation: 0,
            title: Text('Advertisements',style: TextStyle(color: Colors.white),),
            centerTitle: true,
            automaticallyImplyLeading: false,
            actions: [
              PullDownButton(
                applyOpacity: true,
                routeTheme: PullDownMenuRouteTheme(width: 150),
                itemBuilder: (context) => [
                  PullDownMenuItem.selectable(
                    title: 'Latest',
                    selected: cubit.selectIndex==0 ? true:false,
                    onTap: () {
                      cubit.selectIndex=0;
                      cubit.emit(AppChangeFilter());

                    },
                  ),
                  const PullDownMenuDivider(),
                  PullDownMenuItem.selectable(
                    title: 'Older',
                    selected: cubit.selectIndex==1 ? true:false,
                    onTap: () {
                      cubit.selectIndex=1;
                      cubit.emit(AppChangeFilter());
                    },
                  ),
                  const PullDownMenuDivider(),
                  PullDownMenuItem.selectable(
                    title: 'Most likes',
                    selected: cubit.selectIndex==2 ? true:false,
                    onTap: () {
                      cubit.selectIndex=2;
                      cubit.emit(AppChangeFilter());
                    },
                  ),
                ],
                position: PullDownMenuPosition.under,
                buttonBuilder: (context, showMenu) => CupertinoButton(
                  onPressed: showMenu,
                  padding: EdgeInsets.zero,
                  child: const Icon(Icons.sort,color: Colors.white,),
                ),
              ),
            ],
          ),
          body: StreamBuilder<List<AdModel>>(
            stream: cubit.getAds(catName),
            builder: (BuildContext context,
                AsyncSnapshot<List<AdModel>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: HexColor('#69A88D'),
                  ),
                );

              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );

              } else if (!snapshot.hasData) {
                return Center(
                  child: Text('No data'),
                );
              } else {
                List<AdModel> ads = snapshot.data!;
                if(cubit.selectIndex==1){
                  ads.sort((a, b) => a.startDate!.compareTo(b.startDate!));
                }
                if(cubit.selectIndex==2){
                  ads.sort((a, b) => b.likes!.length.compareTo(a.likes!.length));
                }
                else if(cubit.selectIndex==0) {
                  ads.sort((a, b) => b.startDate!.compareTo(a.startDate!));
                }

                return PageView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: ads.length,
                  itemBuilder: (BuildContext context, int index) {
                    return buildAds( cubit, ads[index], context, ads,likeIcon,likeColor, index,);
                  },
                );
              }
            },
          ),
        );
      },
    );
  }

  Widget buildAds(AppBloc cubit,AdModel model,context, List<AdModel> ad,likeIcon,likeColor, int index) {
    return Builder(
      builder: (context) {
        if(model.likes!.contains(cubit.userModel!.uId)){
          likeColor=Colors.red;
          likeIcon=IconlyBold.heart;}
        cubit.deleteAd(model.adId!, model.endDate!);
        return Column(
          children: [
            if(index!=0)
              Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.arrow_left,color: Colors.white,),
                Text("Scroll right",style: TextStyle(color:Colors.white ),),
              ],
            ),
            Expanded(
              flex:12,
              child: Container(
              child: Image(fit:BoxFit.cover,
                image: NetworkImage(model.image!),),
              ),
            ),
            if((index+1)!=ad.length)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("Scroll left",style: TextStyle(color: Colors.white),),
                Icon(Icons.arrow_right,color: Colors.white,),
              ],
            ),
            Expanded(
                  flex:1,
                  child: Container(
                    color: HexColor('#5A5A5A'),
                    child:Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:[
                          IconButton(onPressed: (){
                            navigateTo(context, DetailsScreen(model));
                          }, icon: Icon(Icons.info_outlined,color: Colors.white,)),
                          Text('${ad.length}/${index+1}',style: TextStyle(color: Colors.white,fontSize: 18),),
                          GestureDetector(
                            onTap: ()async{
                              if(model.likes!.contains(cubit.userModel!.uId)){
                                model.likes!.remove(cubit.userModel!.uId);
                              }
                              else{
                                model.likes!.add(cubit.userModel!.uId!);
                              }
                              await cubit.updateLike(model, model.adId!);
                            },
                            child: Row(
                              children: [
                                Icon(likeIcon,color: likeColor,),
                                SizedBox(width: 3,),
                                Text('${model.likes!.length-1}',style: TextStyle(color: Colors.white),),

                              ],
                            ),
                          ),
                        ],
                      ),
                    ) ,
                  ),
                )
          ],
        );
      }
    );

  }


}