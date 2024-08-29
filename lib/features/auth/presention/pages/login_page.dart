import 'package:adphotos/core/componants/components.dart';
import 'package:adphotos/core/strings/constants.dart';
import 'package:adphotos/core/utl/snackbar_message.dart';
import 'package:adphotos/core/vaild/vaild.dart';
import 'package:adphotos/features/auth/presention/pages/signup_page.dart';
import 'package:adphotos/features/auth/presention/widgets/form_widget.dart';
import 'package:adphotos/layout/home/home_screen.dart';
import 'package:adphotos/features/auth/presention/pages/forget_password_page.dart';
import 'package:adphotos/features/auth/presention/bloc/auth_bloc.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccessLoginState) {
          if (uId != null) {
            BlocProvider.of<AuthBloc>(context).add(GetUserDataEvent(uId: uId));
          }
        } else if (state is AuthGetUserSuccessState) {
          navigateAndFinish(context, HomePage());
        } else if (state is AuthErrorLoginState || state is AuthGetUserErrorState) {
         SnackBarMessage().showErrorMessage(context, "Can't login");
        }
      },
      builder: (context, state) {
        final AuthBloc bloc = BlocProvider.of<AuthBloc>(context);
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
                            'Welcome to Ad app',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Text(
                            'Log in',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 32.0,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 20.0),
                          FormWidget(
                            controller: emailController,
                            inputType: TextInputType.emailAddress,
                            prefix: IconlyLight.message,
                            label: 'Email',
                            validator: (val) {
                              return validInput(
                                val: val!,
                                min: 11,
                                max: 25,
                              );
                            },
                          ),
                          SizedBox(height: 10.0),
                          FormWidget(
                            controller: passwordController,
                            inputType: TextInputType.visiblePassword,
                            prefix: IconlyLight.lock,
                            label: 'Password',
                            validator: (val) {
                              return validInput(
                                val: val!,
                                min: 8,
                                max: 15,
                              );
                            },
                          ),
                          SizedBox(height: 10.0),
                          Center(
                            child: TextButton(
                              onPressed: () {
                                navigateTo(context, ForgetPasswordPage());
                              },
                              child: const Text(
                                'Forget password?',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ConditionalBuilder(
                                condition: state is! AuthLoadingLoginState,
                                builder: (context) => Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    // color: HexColor('#f2f2eb'),
                                  ),
                                  height: 50.0,
                                  width: 300,
                                  child: MaterialButton(
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        bloc.add(
                                          LoginEvent(
                                            email: emailController.text,
                                            password: passwordController.text,
                                          ),
                                        );
                                      }
                                    },
                                    child: Text(
                                      'Log in',
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                fallback: (context) => Center(
                                  child: CircularProgressIndicator(
                                    // color: HexColor('#f2f2eb'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'or',
                                style: TextStyle(fontSize: 20, color: Colors.white),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  // color: HexColor('#f2f2eb'),
                                ),
                                height: 50.0,
                                width: 300,
                                child: MaterialButton(
                                  onPressed: () {
                                    navigateTo(context, SignupPage());
                                  },
                                  child: Text(
                                    'Create an account',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
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
