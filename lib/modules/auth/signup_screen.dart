import 'package:adphotos/modules/auth/login_screen.dart';
import 'package:adphotos/shared/bloc/app/appbloc.dart';
import 'package:adphotos/shared/bloc/app/appstatus.dart';
import 'package:adphotos/shared/bloc/auth/authbloc.dart';
import 'package:adphotos/shared/bloc/auth/authstatus.dart';
import 'package:adphotos/shared/componants/components.dart';
import 'package:adphotos/shared/vaild/vaild.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:iconly/iconly.dart';


class SignUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    var usernameController = TextEditingController();
    var emailController = TextEditingController();
    var numController = TextEditingController();
    var passwordController = TextEditingController();
    var confirmpasswordController = TextEditingController();
    var cubit=AuthBloc.get(context);
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccessCreateUserState)
          navigateAndFinish(context, LoginScreen());
      },
      builder: (context, state) {
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
                          SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            'Sign up',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 32.0,
                                color: Colors.white),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          defaultTextForm(
                            controller: usernameController,
                            inputType: TextInputType.name,
                            prefix: IconlyLight.user,
                            lable: 'Username',
                            validator:(val){
                              return validInput(
                                  val:val!,
                                  min:2,
                                  max:20);
                            } ,                            ),
                          SizedBox(
                            height: 10.0,
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
                            controller: numController,
                            inputType: TextInputType.phone,
                            prefix: Icons.phone,
                            lable: 'Phone',
                            validator:(val){
                              return validInput(
                                  val:val!,
                                  min:10,
                                  max:10);
                            } ,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          defaultTextForm(
                            controller: passwordController,
                            inputType: TextInputType.visiblePassword,
                            prefix: IconlyLight.lock,
                            suffix: cubit.isShowSignUp
                                ? Icons.visibility
                                : Icons.visibility_off,
                            suffixPressed: AuthBloc.get(context).registerChangePasswordToShow,
                            lable: 'Password',
                           textShow: cubit.isShowSignUp,
                            validator:(val){
                              return validInput(
                                  val:val!,
                                  min:8,
                                  max:15);
                            } ,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            obscureText: cubit.isShowSignUp,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Re-Password',
                              labelStyle: TextStyle(color: Colors.white),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: HexColor('#ffffff')),
                              ),
                              prefixIcon: Icon(IconlyLight.lock,
                                  color: HexColor('#ffffff'), size: 20.0),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    cubit
                                        .registerChangePasswordToShow();
                                  },
                                  icon: cubit.isShowSignUp
                                      ? Icon(Icons.visibility,color: Colors.white,)
                                      : Icon(Icons.visibility_off,color: Colors.white)),
                            ),
                            controller: confirmpasswordController,
                            validator: (value) {
                              if (value != passwordController.text) {
                                return 'Password not matched';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          ConditionalBuilder(
                            condition: state is! AuthLoadingRegisterState,
                            builder: (context) => Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: HexColor('#f2f2eb'),
                              ),
                              height: 50.0,
                              width: double.infinity,
                              child: MaterialButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    cubit.userRegister(
                                        name: usernameController.text,
                                        email: emailController.text,
                                        password: passwordController.text,
                                        num: numController.text);
                                  }
                                },
                                child: Text(
                                  'Sign up',
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
                                  color: HexColor('#9cabb4'),
                                )),
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
