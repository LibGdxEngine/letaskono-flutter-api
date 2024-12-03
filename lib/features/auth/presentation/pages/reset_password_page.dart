import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc.dart';

class ResetPasswordPage extends StatefulWidget {
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
        SnackBar(content: Text("Please enter a valid email address.")),
      );
      return;
    }

    setState(() {
      _email = _emailController.text;
      _isFirstTime = false;
    });
    BlocProvider.of<AuthBloc>(context).add(PasswordResetEvent(_email));

    _startTimer();
  }

  void _changPassword() {
    if (_codeController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a code and new password.")),
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
        title: Text("Reset Password"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthPasswordResetEmailSent) {
              setState(() {
                // _isEmailSubmitted = true;
              });
            } else if (state is AuthPasswordVerified) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Password reset successful!")),
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
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _isButtonDisabled ? null : _sendOrResendEmail,
                      child: Text(_isButtonDisabled
                          ? "Resend in $_counter seconds"
                          : _isFirstTime
                              ? "Send Email"
                              : "Resend"),
                    ),
                  ],
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "A reset code was sent to your email: $_email",
                      style: TextStyle(fontSize: 16, color: Colors.green),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _codeController,
                      decoration: InputDecoration(
                        labelText: "Enter Code",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: "New Password",
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _changPassword,
                      child: Text("Reset Password"),
                    ),
                    TextButton(
                      onPressed: _reEnterEmail,
                      child: Text("Re-enter Email"),
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
