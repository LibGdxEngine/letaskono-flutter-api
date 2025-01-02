import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:letaskono_flutter/core/utils/CustomButton.dart';
import 'package:letaskono_flutter/core/utils/CustomTextField.dart';
import 'package:letaskono_flutter/core/utils/ExpandingCircleProgress.dart';
import 'package:letaskono_flutter/core/utils/SecureStorage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bloc/auth_bloc.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _obscureText = true;
  final _prefs = GetIt.instance<SharedPreferences>();

  // Define the controllers
  final TextEditingController emailController = TextEditingController(text: "");
  final TextEditingController passwordController =
      TextEditingController(text: "");

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
        listener: (context, state) async {
          switch (state) {
            case AuthSuccess():
            Navigator.pushNamedAndRemoveUntil(
                context, '/users', (route) => false);
            case AuthFailure():
               if (state.message.contains("لم يتم تأكيد حسابك بعد")) {
                Navigator.pushNamed(context, '/confirm', arguments: {
                  'email': emailController.text,
                  'password': passwordController.text,
                });
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
          }
        },
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'وَمِنْ آَيَاتِهَ أَنْ خَلَقَ لَكُمْ مِنْ أَنْفُسِكُمْ أَزْوَاجَاً لِتَسْكُنُواْ إِلَيْهَا وَجَعَلَ بَيْنَكُمْ مَوَدَةً وَرَحْمَةً إِن فِي ذَلِكَ لَآَيَاتٍ لِقَوْمٍ يَتَفَكَرُونَ',
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 8),
                        child: Image.asset(
                          'assets/images/3demail_icon.png',
                          width: 100,
                          height: 100,
                        ),
                      ),
                      CustomTextField(
                        controller: emailController,
                        hintText: 'البريد الإلكتروني',
                        keyboardType: TextInputType.emailAddress,
                        preIconPadding: 11,
                        prefixIcon: Image.asset(
                          'assets/images/email_icon.png',
                          width: 1,
                          height: 1,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      CustomTextField(
                        controller: passwordController,
                        hintText: 'كلمة السر',
                        obscureText: _obscureText,
                        keyboardType: TextInputType.visiblePassword,
                        prefixIcon: Image.asset(
                          'assets/images/shield_icon.png',
                          width: 1,
                          height: 1,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        suffixIcon: IconButton(
                          icon: Image.asset(
                            _obscureText
                                ? 'assets/images/visibility_off.png' // Eye icon for hidden password
                                : 'assets/images/visibility_on.png',
                            // Eye icon for visible password
                            // Eye icon for visibility toggle
                            width: 24,
                            height: 24,
                          ),
                          onPressed: () {
                            // Toggle visibility logic here
                            setState(() {
                              _obscureText =
                                  !_obscureText; // Toggle the visibility
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
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
                              String email = emailController.text.toLowerCase().trim();
                              String password = passwordController.text.trim();

                              // Add the SignInEvent to the AuthBloc
                              BlocProvider.of<AuthBloc>(context)
                                  .add(SignInEvent(email, password));
                            },
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            textColor: Colors.white,
                          );
                        },
                      ),
                      const SizedBox(height: 32),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "أليس لديك حساب ؟",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              // Remove padding
                              minimumSize: Size.zero,
                              // Remove the minimum size (if any)
                              tapTargetSize: MaterialTapTargetSize
                                  .shrinkWrap, // Shrink the tap target size
                            ),
                            onPressed: () {
                              // Navigate to the reset password page
                              Navigator.pushReplacementNamed(
                                  context, '/signup');
                            },
                            child: Text(
                              "قم بإنشاء حساب جديد",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Column(
                        children: [
                          Text(
                            "هل نسيت كلمة السر ؟",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              // Remove padding
                              minimumSize: Size.zero,
                              // Remove the minimum size (if any)
                              tapTargetSize: MaterialTapTargetSize
                                  .shrinkWrap, // Shrink the tap target size
                            ),
                            onPressed: () {
                              // Navigate to the reset password page
                              Navigator.pushNamed(context, '/resetPassword');
                            },
                            child: Text(
                              "إعادة تعيين كلمة السر",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
