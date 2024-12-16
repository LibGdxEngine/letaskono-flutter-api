import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:letaskono_flutter/core/utils/CustomButton.dart';
import 'package:letaskono_flutter/core/utils/CustomTextField.dart';
import 'package:letaskono_flutter/core/utils/ExpandingCircleProgress.dart';

import '../bloc/auth_bloc.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  // Define the controllers
  final TextEditingController emailController =
      TextEditingController(text: "ahmed1@gmail.com");
  final TextEditingController passwordController =
      TextEditingController(text: "ahmed1998");

  @override
  void dispose() {
    // Dispose of the controllers when the widget is removed
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          switch (state) {
            case AuthSuccess():
              Navigator.pushNamedAndRemoveUntil(
                  context, '/users', (route) => false);
            case AuthFailure():
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(children: [
                    Positioned(
                      child: Image.asset(
                        'assets/images/auth_banner.png',
                        width: 300,
                        height: 200,
                      ),
                    ),

                  ]),
                  CustomTextField(
                    controller: emailController,
                    hintText: 'البريد الإلكتروني',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Image.asset(
                      'assets/images/profile_icon.png',
                      width: 1,
                      height: 1,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  CustomTextField(
                    controller: passwordController,
                    hintText: 'كلمة السر',
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    prefixIcon: Image.asset(
                      'assets/images/shield_icon.png',
                      width: 1,
                      height: 1,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    suffixIcon: IconButton(
                      icon: Image.asset(
                        'assets/images/visibility_off.png',
                        // Eye icon for visibility toggle
                        width: 24,
                        height: 24,
                      ),
                      onPressed: () {
                        // Toggle visibility logic here
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      switch (state) {
                        case AuthLoading():
                          return ExpandingCircleProgress();
                      }
                      return CustomButton(
                        text: 'تسجيل الدخول',
                        icon: 'assets/images/signin_icon.png',
                        iconBackgroundColor: Colors.white,
                        onPressed: () {
                          // Handle sign in action
                          String email = emailController.text;
                          String password = passwordController.text;

                          // Add the SignInEvent to the AuthBloc
                          BlocProvider.of<AuthBloc>(context)
                              .add(SignInEvent(email, password));
                        },
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        textColor: Colors.white,
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("أليس لديك حساب ؟"),
                      TextButton(
                        onPressed: () {
                          // Navigate to the reset password page
                          Navigator.pushReplacementNamed(context, '/signup');
                        },
                        child: Text("قم بإنشاء حساب جديد"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Text("هل نسيت كلمة السر ؟"),
                      TextButton(
                        onPressed: () {
                          // Navigate to the reset password page
                          Navigator.pushNamed(context, '/resetPassword');
                        },
                        child: const Text("إعادة تعيين كلمة السر"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
