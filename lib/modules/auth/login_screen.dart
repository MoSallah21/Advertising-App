import 'package:adphotos/layout/home/home_screen.dart';
import 'package:adphotos/modules/auth/forget_password.dart';
import 'package:adphotos/modules/auth/signup_screen.dart';
import 'package:adphotos/shared/bloc/auth/authbloc.dart';
import 'package:adphotos/shared/bloc/auth/authstatus.dart';
import 'package:adphotos/shared/componants/components.dart';
import 'package:adphotos/shared/network/local/remot/cachehelper.dart';
import 'package:adphotos/shared/vaild/vaild.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:iconly/iconly.dart';

class LoginScreen extends StatelessWidget {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {

        if (state is AuthSuccessLoginState) {
          CacheHelper.saveData(key: 'uId', value: state.uId);
          navigateAndFinish(context, HomeScreen());
        }
      },
      builder: (context, state) {
        var cubit=AuthBloc.get(context);
        return SafeArea(
          child: Scaffold(
            body: Container(
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/image/background2.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 40),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome to ad app',
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            'Log in',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 32.0,
                                color: Colors.white),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          defaultTextForm(
                            controller: emailController,
                            inputType: TextInputType.emailAddress,
                            prefix: IconlyLight.message,
                            lable: 'Email',
                            validator:(val){
                              return validInput(
                                  val:val!,
                                  min:11,
                                  max:25);
                            } ,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          defaultTextForm(
                            controller: passwordController,
                            inputType: TextInputType.visiblePassword,
                            prefix: IconlyLight.lock,
                            suffix: cubit.isShowLogin
                                ? Icons.visibility
                                : Icons.visibility_off,
                            suffixPressed: cubit.loginChangePasswordToShow,
                            lable: 'Password',
                            textShow: cubit.isShowLogin,
                            validator:(val){
                              return validInput(
                                  val:val!,
                                  min:8,
                                  max:15);
                            } ,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Center(child: TextButton(onPressed: ()
                          {
                            navigateTo(context, ForgetMyPassword());

                          }, child: const Text('Forget password ?',style: TextStyle(color: Colors.white),))),
                          SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ConditionalBuilder(
                                condition: state is! AuthLoadingLoginState,
                                builder: (context) => Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    color: HexColor('#f2f2eb'),
                                  ),
                                  height: 50.0,
                                  width: 300,
                                  child: MaterialButton(
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        cubit.getUserData();
                                        cubit.signIn(
                                            email: emailController.text,
                                            password: passwordController.text);
                                      }
                                    },
                                    child: Text(
                                      'Log in',
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                fallback: (context) => Center(
                                    child: CircularProgressIndicator(
                                      color: HexColor('#f2f2eb'),
                                    )),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'or',
                                style: TextStyle(fontSize: 20,color: Colors.white),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: HexColor('#f2f2eb'),
                                ),
                                height: 50.0,
                                width: 300,
                                child: MaterialButton(
                                  onPressed: () {
                                    navigateTo(context, SignUp());
                                  },
                                  child: Text(
                                    'Create an account',
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
