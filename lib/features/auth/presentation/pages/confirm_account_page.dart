import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:letaskono_flutter/core/utils/CustomButton.dart';
import 'package:letaskono_flutter/core/utils/CustomTextField.dart';
import 'package:letaskono_flutter/core/utils/ExpandingCircleProgress.dart';

import '../bloc/auth_bloc.dart';

class ConfirmCodePage extends StatelessWidget {
  late final TextEditingController codeController;
  final String? email;
  final String? password;

  ConfirmCodePage({super.key, required this.email, required this.password}) {
    codeController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          switch (state) {
            case AuthProfileSetup():
              BlocProvider.of<AuthBloc>(context)
                  .add(SignInEvent(email!, password!));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text("Account confirmed, enter your data")),
              );
              Navigator.pushNamedAndRemoveUntil(
                  context, '/profileSetup', (route) => false);
            case AuthFailure():
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
          }
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'قم بتأكيد حسابك',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(
                                height: 1.5,
                                fontWeight: FontWeight.bold,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'ستصلك رسالة برمز التأكيد على بريدك الإلكتروني ${email}',
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    height: 1.5,
                                    fontWeight: FontWeight.w500,
                                  ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  CustomTextField(
                    controller: codeController,
                    hintText: 'رمز التأكيد',
                    keyboardType: TextInputType.text,
                    preIconPadding: 11,
                    prefixIcon: Image.asset(
                      'assets/images/email_icon.png',
                      width: 1,
                      height: 1,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      if (state is AuthLoading) {
                        return ExpandingCircleProgress();
                      }
                      return CustomButton(
                        text: 'تفعيل الحساب',
                        icon: 'assets/images/confirm_icon.png',
                        iconBackgroundColor: Colors.white,
                        onPressed: () {
                          // Handle code confirmation logic
                          BlocProvider.of<AuthBloc>(context)
                              .add(ConfirmCodeEvent(codeController.text));
                        },
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        textColor: Colors.white,
                      );
                    },
                  ),
                  const SizedBox(height: 32,),
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
                      Navigator.pop(context);
                    },
                    child: Text(
                      "هل تريد تعديل البريد الإلكتروني ؟",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
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
