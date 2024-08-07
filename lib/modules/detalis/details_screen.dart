import 'package:adphotos/models/ad/ad.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart' as intl;
import 'package:adphotos/modules/detalis/view.dart';
import 'package:adphotos/shared/bloc/app/appbloc.dart';
import 'package:adphotos/shared/bloc/app/appstatus.dart';
import 'package:adphotos/shared/componants/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';

class DetailsScreen extends StatelessWidget {
  AdModel adModel;

  DetailsScreen(this.adModel);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppBloc,AppState>(
      listener: (BuildContext context, Object? state) {  },
      builder: (BuildContext context, state) {
        var cubit=AppBloc.get(context);
        String dateString = adModel.startDate!;
        DateTime dateTime = DateTime.parse(dateString);
        String formattedDate = intl.DateFormat('yyyy-MM-dd').format(dateTime);

        return Scaffold(
          appBar: AppBar(
            backgroundColor: HexColor('#5A5A5A'),
            centerTitle: true,
            title: const Text(
              'Details',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
            ),
            actions: [
              Icon(Icons.info_outlined,color: Colors.white,),
              SizedBox(width: 10,),

            ],
          ),
          body: Container(
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/image/gray.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      width: double.infinity,
                      height: 420,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.01),
                      ),
                      child: GestureDetector(
                        onDoubleTap: (){
                          navigateTo(context, ViewScreen(adModel.image!));
                        },
                        child: Image(
                            image: NetworkImage(adModel.image!)),
                      )
                  ),
                  SizedBox(
                    height: 5,
                  ),

                  if(adModel.vip!)
                    Row(
                      children: [
                        SizedBox(width: 5,),
                        Icon(Icons.star,color: Colors.yellow,),
                      ],
                    ),
                  if(adModel.vip!)
                    SizedBox(height: 8,),
                  Row(
                    children: [
                      SizedBox(
                        width: 4,
                      ),
                      Icon(IconlyLight.document,color: Colors.black,),
                      SizedBox(
                        width: 4,
                      ),
                      const Text('Name of place :',style: TextStyle(color: Colors.black),),
                      SizedBox(
                        width: 4,
                      ),
                      Expanded(
                          child: Text(
                            '${adModel.shopName}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 4,
                      ),
                      Icon(IconlyLight.category,color: Colors.black,),
                      SizedBox(
                        width: 4,
                      ),
                      const Text('Ad type :',style: TextStyle(color: Colors.black),),
                      SizedBox(
                        width: 4,
                      ),
                      Text('${adModel.catName}',style: TextStyle(color: Colors.black),),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 4,
                      ),
                      Icon(IconlyLight.call,color: Colors.black,),
                      SizedBox(
                        width: 4,
                      ),
                      const Text('Phone :',style: TextStyle(color: Colors.black),),
                      SizedBox(
                        width: 4,
                      ),
                      TextButton(child: Text('${adModel.userNum}'),onPressed: (){
                        cubit.launchWhatsApp(phone: '${adModel.userNum}',title: 'Hey i need to know the details');
                      },),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 4,
                      ),
                      Icon(IconlyLight.time_circle,color: Colors.black,),
                      SizedBox(
                        width: 4,
                      ),
                      const Text('Date added :',style: TextStyle(color: Colors.black),),
                      SizedBox(
                        width: 4,
                      ),
                      Text('$formattedDate',style: TextStyle(color: Colors.black),),
                    ],
                  ),

                ],
              ),
            ),
          ),
        );
      },
    );

  }
}
