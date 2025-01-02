import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:letaskono_flutter/core/utils/CustomButton.dart';
import 'package:letaskono_flutter/core/utils/CustomTextField.dart';
import 'package:letaskono_flutter/core/utils/ExpandingCircleProgress.dart';
import 'package:letaskono_flutter/core/utils/SecureStorage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bloc/auth_bloc.dart';

class ConfirmCodePage extends StatefulWidget {
  late final TextEditingController codeController;
  final String? email;
  final String? password;

  ConfirmCodePage({super.key, required this.email, required this.password}) {
    codeController = TextEditingController();
  }

  @override
  State<ConfirmCodePage> createState() => _ConfirmCodePageState();
}

class _ConfirmCodePageState extends State<ConfirmCodePage> {
  final _prefs = GetIt.instance<SharedPreferences>();
  bool needEmailAgain = false;
  final emailController = TextEditingController();

  int remainingTime = 0; // Countdown in seconds
  Timer? countdownTimer; // Timer instance

  void startCountdown() {
    // Reset countdown to 60 seconds
    setState(() {
      remainingTime = 60;
    });

    // Start the timer
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingTime > 0) {
          remainingTime--;
        } else {
          countdownTimer?.cancel(); // Cancel the timer when countdown is over
        }
      });
    });
  }

  @override
  void dispose() {
    // Dispose of the timer to avoid memory leaks
    countdownTimer?.cancel();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          switch (state) {
            case AuthProfileSetup():
              final key1 = SecureStorage.decryptText(
                  _prefs.getString("auth_key_1") ?? '');
              final key2 = SecureStorage.decryptText(
                  _prefs.getString("auth_key_2") ?? '');
              BlocProvider.of<AuthBloc>(context).add(SignInEvent(key1, key2));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    duration: Duration(seconds: 5),
                    content: Text(
                        "لقد تم تأكيد حسابك, أدخل بياناتك لتفعيله بشكل كامل")),
              );
              Navigator.pushNamedAndRemoveUntil(
                  context, '/profileSetup', (route) => false);
            case ActivationEmailResent():
              startCountdown(); // Start the countdown when the email is resent
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم إعادة إرسال الكود')),
              );
              break;
            case ResendingActivationFailed():
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
              break;
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
                          'ستصلك رسالة برمز التأكيد على بريدك الإلكتروني ${widget.email}',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                            height: 1.5,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  CustomTextField(
                    controller: widget.codeController,
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

                          BlocProvider.of<AuthBloc>(context).add(
                              ConfirmCodeEvent(widget.codeController.text));
                        },
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        textColor: Colors.white,
                      );
                    },
                  ),
                  const SizedBox(height: 32),
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
                  const SizedBox(height: 32),
                  Text('إذا لم يصلك كود التفعيل خلال ثوان قليلة فيمكنك', style: Theme.of(context).textTheme.bodySmall,),
                  needEmailAgain
                      ? CustomTextField(
                    controller: emailController,
                    hintText: 'نحتاج تأكيد البريد الالكتروني مرة أخرى',
                    keyboardType: TextInputType.text,
                    preIconPadding: 11,
                    prefixIcon: Image.asset(
                      'assets/images/email_icon.png',
                      width: 1,
                      height: 1,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  )
                      : Container(),
                  const SizedBox(height: 16),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: remainingTime == 0
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey, // Disable button during countdown
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: remainingTime == 0
                        ? () {
                      final email =
                          _prefs.getString("auth_key_1") ?? '';
                      if (email.isEmpty &&
                          emailController.text.trim().isEmpty) {
                        setState(() {
                          needEmailAgain = true;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'يجب أن تدخل البريد الالكتروني مرة أخرى')));
                        return;
                      }
                      final key1 = email.isNotEmpty
                          ? SecureStorage.decryptText(email)
                          : emailController.text.toLowerCase().trim();
                      BlocProvider.of<AuthBloc>(context).add(
                          ResendActivationCodeEvent(key1));
                    }
                        : null, // Disable button when countdown is active
                    child: Text(
                      remainingTime == 0
                          ? "إعادة إرسال كود التفعيل ؟"
                          : "انتظر $remainingTime ثانية لإعادة الإرسال",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold, color: Colors.white),
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

