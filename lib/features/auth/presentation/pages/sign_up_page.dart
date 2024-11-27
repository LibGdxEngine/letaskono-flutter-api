import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';

class SignUpPage extends StatelessWidget {
  final TextEditingController firstNameController =
  TextEditingController(text: "first namess");
  final TextEditingController lastNameController =
  TextEditingController(text: "last name");
  final TextEditingController emailController =
  TextEditingController(text: "ahmed11@gmail.com");
  final TextEditingController passwordController =
  TextEditingController(text: "ahmed1998");

  SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          // Handle success and failure states
          switch (state) {
            case AuthConfirmationCodeSent():
              Navigator.pushNamed(context, '/confirm', arguments: {
                'email': emailController.text,
                'password': passwordController.text,
              });
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
              TextField(
                controller: firstNameController,
                decoration: const InputDecoration(hintText: 'First Name'),
              ),
              TextField(
                controller: lastNameController,
                decoration: const InputDecoration(hintText: 'Last Name'),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(hintText: 'Email'),
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(hintText: 'Password'),
                obscureText: true,
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
                      // Dispatch the sign-up event with user input data
                      BlocProvider.of<AuthBloc>(context).add(
                        SignUpEvent(
                          firstNameController.text,
                          lastNameController.text,
                          emailController.text,
                          passwordController.text,
                        ),
                      );
                    },
                    child: const Text('Sign Up'),
                  );
                },
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signin');
                },
                child: const Text('Already have an account? Sign In'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
