import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Sign In'),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(hintText: 'Email'),
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(hintText: 'Password'),
                obscureText: true, // Hide the password input
              ),
              const SizedBox(height: 20),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  switch (state) {
                    case AuthLoading():
                      return const CircularProgressIndicator();
                  }
                  return ElevatedButton(
                    onPressed: () {
                      // Handle sign in action
                      String email = emailController.text;
                      String password = passwordController.text;

                      // Add the SignInEvent to the AuthBloc
                      BlocProvider.of<AuthBloc>(context)
                          .add(SignInEvent(email, password));
                    },
                    child: const Text('Sign In'),
                  );
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?"),
                  TextButton(
                    onPressed: () {
                      // Navigate to the reset password page
                      Navigator.pushReplacementNamed(context, '/signup');
                    },
                    child: Text("Create Account"),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text("Forgot your password?"),
              TextButton(
                onPressed: () {
                  // Navigate to the reset password page
                  Navigator.pushNamed(context, '/resetPassword');
                },
                child: Text("Reset Password"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
