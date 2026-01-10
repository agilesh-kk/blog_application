import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/auth/presentation/pages/signin_page.dart';
import 'package:blog_app/features/auth/presentation/widgets/auth_fields.dart';
import 'package:blog_app/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SignupPage extends StatefulWidget {
  static const String pageName = 'signUpPage';
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(10),

        //wrapping the entire form for bloc
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state){
            if(state is AuthFailure){
              showSnackbar(context, state.message);
            }
            
            //if sigining up the user is successful then it routes to blogpage.
            else if(state is AuthSuccess){
              context.goNamed(BlogPage.pageName);
            }
          },
          builder: (context, state){
            if(state is AuthLoading){
              return const Loader();
            }

            return Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Sign Up.",
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 25),
                  AuthFields(hintText: 'Name', controller: nameController),
                  const SizedBox(height: 15),
                  AuthFields(hintText: 'Email', controller: emailController),
                  const SizedBox(height: 15),
                  AuthFields(
                    hintText: 'Password',
                    controller: passwordController,
                    isObsucure: true,
                  ),
                  const SizedBox(height: 20),
                  AuthGradientButton(
                    buttonText: 'Sign Up',
                    onPressed: () {
                      if(formKey.currentState!.validate()){
                        context.read<AuthBloc>().add(
                          AuthSignUp(
                            name: nameController.text.trim(),
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 20),
            
                  GestureDetector(
                    onTap: () {
                      context.goNamed(
                        SigninPage.pageName,
                      ); //navigates to sing in page
                    },
                    child: RichText(
                      //used for placing 2 text widgets in a single line.
                      text: TextSpan(
                        text: 'Already have an account? ',
                        style: Theme.of(context).textTheme.titleMedium,
                        children: [
                          TextSpan(
                            text: 'Sign In',
                            style: TextStyle(
                              color: AppPallete.gradient2,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        ),
      ),
    );
  }
}

