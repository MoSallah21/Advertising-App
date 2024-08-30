import 'package:adphotos/core/vaild/vaild.dart';
import 'package:adphotos/features/auth/presention/bloc/auth_bloc.dart';
import 'package:adphotos/features/auth/presention/widgets/form_widget.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:iconly/iconly.dart';


class ForgetPasswordPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, Object? state) {
        final AuthBloc bloc = BlocProvider.of<AuthBloc>(context);
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
                      child: FormWidget(
                        controller: emailController,
                        inputType: TextInputType.emailAddress,
                        prefix: IconlyLight.message,
                        label: 'Enter your email',
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
                          condition: state is! AuthLoadingForgetPasswordState,
                          builder: (BuildContext context) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                // color: HexColor('#f2f2eb'),
                              ),
                              height: 50.0,
                              width: 300,
                              child: MaterialButton(
                                onPressed: () {
                                  if(formKey.currentState!.validate()){
                                    bloc.add(ForgetPasswordEvent(email: emailController.text));
                                  }
                                },
                                child: Text(
                                  'Rest Password',
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
