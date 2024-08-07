import 'package:adphotos/shared/bloc/auth/authbloc.dart';
import 'package:adphotos/shared/bloc/auth/authstatus.dart';
import 'package:adphotos/shared/componants/components.dart';
import 'package:adphotos/shared/vaild/vaild.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:iconly/iconly.dart';


class ForgetMyPassword extends StatelessWidget {
  var emailController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, Object? state) {
        var cubit=AuthBloc.get(context);
        return Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/image/background2.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 100),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '  Rest Password',
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: defaultTextForm(
                        controller: emailController,
                        inputType: TextInputType.emailAddress,
                        prefix: IconlyLight.message,
                        lable: 'Enter your email',
                        validator:(val){
                          return validInput(
                              val:val!,
                              min:11,
                              max:25);
                        } ,
                      ),
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ConditionalBuilder(
                          condition: state is! AuthLoadingRestPasswordState,
                          builder: (BuildContext context) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: HexColor('#f2f2eb'),
                              ),
                              height: 50.0,
                              width: 300,
                              child: MaterialButton(
                                onPressed: () {
                                  if(formKey.currentState!.validate()){
                                  cubit.resetPassword(
                                      email: emailController.text);
                                  }
                                },
                                child: Text(
                                  'Rest',
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          },
                          fallback: (BuildContext context) {
                            return Center(
                                child: CircularProgressIndicator(
                              color: HexColor('#69A88D'),
                            ));
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
