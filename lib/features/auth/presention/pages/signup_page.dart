import 'package:adphotos/core/componants/components.dart';
import 'package:adphotos/core/vaild/vaild.dart';
import 'package:adphotos/features/auth/presention/pages/login_page.dart';
import 'package:adphotos/features/auth/presention/widgets/form_widget.dart';
import 'package:adphotos/features/auth/presention/bloc/auth_bloc.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';


class SignupPage extends StatelessWidget {
  final  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final  TextEditingController usernameController = TextEditingController();
  final  TextEditingController emailController = TextEditingController();
  final  TextEditingController numController = TextEditingController();
  final  TextEditingController passwordController = TextEditingController();
  final  TextEditingController confirmPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final AuthBloc bloc = BlocProvider.of<AuthBloc>(context);
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccessRegisterState)
          navigateAndFinish(context, LoginPage());
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
                          FormWidget(
                            controller: usernameController,
                            inputType: TextInputType.name,
                            prefix: IconlyLight.user,
                            label: 'Username',
                            validator:(val){
                              return validInput(
                                  val:val!,
                                  min:2,
                                  max:20);
                            } ,                            ),
                          SizedBox(
                            height: 10.0,
                          ),
                          FormWidget(
                            controller: emailController,
                            inputType: TextInputType.emailAddress,
                            prefix: IconlyLight.message,
                            label: 'Email',
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
                          FormWidget(
                            controller: numController,
                            inputType: TextInputType.phone,
                            prefix: Icons.phone,
                            label: 'Phone',
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
                          FormWidget(
                            controller: passwordController,
                            inputType: TextInputType.visiblePassword,
                            prefix: IconlyLight.lock,
                            label: 'Password',
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
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Re-Password',
                              labelStyle: TextStyle(color: Colors.white),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              // focusedBorder: OutlineInputBorder(
                              //   borderSide:
                              //   // BorderSide(color: HexColor('#ffffff')),
                              // ),
                              prefixIcon: Icon(IconlyLight.lock
                                  // color: HexColor('#ffffff')
                                  , size: 20.0),
                            ),
                            controller: confirmPasswordController,
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
                                // color: HexColor('#f2f2eb'),
                              ),
                              height: 50.0,
                              width: double.infinity,
                              child: MaterialButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    bloc.add(SignupEvent(
                                        username: usernameController.text,
                                        email: emailController.text,
                                        num: numController.text,
                                        password: passwordController.text));
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
                                  // color: HexColor('#9cabb4'),
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
