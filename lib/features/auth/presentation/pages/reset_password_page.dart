import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:letaskono_flutter/core/utils/CustomButton.dart';
import 'package:letaskono_flutter/core/utils/CustomTextField.dart';

import '../bloc/auth_bloc.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  bool _isEmailSubmitted = false;
  bool _isButtonDisabled = false;
  bool _isFirstTime = true;
  int _counter = 60;
  String _email = "";
  Timer? _timer;

  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();

  void _startTimer() {
    setState(() {
      _isButtonDisabled = true;
      _counter = 60;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_counter > 0) {
        setState(() {
          _counter--;
        });
      } else {
        _timer?.cancel();
        setState(() {
          _isButtonDisabled = false;
        });
      }
    });
  }

  void _sendOrResendEmail() {
    if (_emailController.text.isEmpty || !_emailController.text.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("من فضلك أدخل بريد إلكتروني صحيح")),
      );
      return;
    }

    setState(() {
      _email = _emailController.text;
      _isFirstTime = false;
    });
    BlocProvider.of<AuthBloc>(context)
        .add(PasswordResetEvent(_email.toLowerCase()));

    _startTimer();
  }

  void _changPassword() {
    if (_codeController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("من فضلك أدخل الكود وكلمة السر الجديدة")),
      );
      return;
    }
    BlocProvider.of<AuthBloc>(context).add(
        PasswordVerifyEvent(_codeController.text, _passwordController.text));
  }

  void _reEnterEmail() {
    setState(() {
      _isEmailSubmitted = false;
      _emailController.clear();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _emailController.dispose();
    _codeController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
          "استعادة كلمة السر",
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthPasswordResetEmailSent) {
              setState(() {
                _isEmailSubmitted = true;
              });
            } else if (state is AuthPasswordVerified) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("تم تعيين كلمة سر جديدة بنجاح")),
              );
              Navigator.pushReplacementNamed(context, '/signin');
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!_isEmailSubmitted)
                Column(
                  children: [
                    Container(
                      width: 70, // Adjust width as needed
                      height: 70, // Adjust height as needed
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.circular(
                            10), // Adjust radius as needed
                      ),
                      child: Center(
                        child: Image.asset(
                          'assets/images/lock_icon.png',
                          width: 45,
                          height: 45,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    CustomTextField(
                      controller: _emailController,
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
                    const SizedBox(height: 16),
                    CustomButton(
                      text: _isButtonDisabled
                          ? "إرسال مجددا بعد $_counter ثانية"
                          : _isFirstTime
                              ? "إرسال رمز الاستعادة"
                              : "إعادة الإرسال",
                      icon: 'assets/images/signin_icon.png',
                      iconBackgroundColor: Colors.white,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      onPressed: _isButtonDisabled ? null : _sendOrResendEmail,
                      textColor: Colors.white,
                    ),
                  ],
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "تم إرسال كود استعادة كلمة السر إلى $_email",
                      style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _codeController,
                      keyboardType: TextInputType.number,
                      hintText: 'كود الاستعادة',
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _passwordController,
                      keyboardType: TextInputType.text,
                      hintText: "كلمة السر الجديدة",
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _changPassword,
                      child: const Text("إعادة تعيين كلمة السر"),
                    ),
                    TextButton(
                      onPressed: _reEnterEmail,
                      child: const Text(
                        "أو يمكنك تعديل البريد الالكتروني",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
