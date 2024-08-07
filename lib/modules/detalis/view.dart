
import 'package:adphotos/shared/bloc/app/appbloc.dart';
import 'package:adphotos/shared/bloc/app/appstatus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_view/photo_view.dart';


class ViewScreen extends StatelessWidget {
  String img;
  ViewScreen(this.img);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppBloc,AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
            body: Container(
            height: double.infinity,
            decoration: BoxDecoration(
            image: DecorationImage(
            image: AssetImage('assets/image/background2.jpg'),
             fit: BoxFit.cover,
         ),
            ),
            child: Container(
                child: PhotoView(
                  imageProvider: NetworkImage(img,
                  ),
                )
            ),

            ),

        );
      },
    );
  }
}