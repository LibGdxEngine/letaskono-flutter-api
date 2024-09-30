import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';

class SignUpPage extends StatelessWidget {
  final TextEditingController firstNameController =
  TextEditingController(text: "first namess");
  final TextEditingController lastNameController =
  TextEditingController(text: "last name");
  final TextEditingController emailController =
  TextEditingController(text: "ahmed@gmail.com");
  final TextEditingController passwordController =
  TextEditingController(text: "ahmed1998");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          // Handle success and failure states
          if (state is AuthConfirmationCodeSent) {
            // Navigate to confirmation page on successful sign-up
            Navigator.pushNamed(context, '/confirm', arguments: {
              'email': emailController.text,
              'password': passwordController.text,
            });
          } else if (state is AuthFailure) {
            // Show error message using a SnackBar
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
                decoration: InputDecoration(hintText: 'First Name'),
              ),
              TextField(
                controller: lastNameController,
                decoration: InputDecoration(hintText: 'Last Name'),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(hintText: 'Email'),
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(hintText: 'Password'),
                obscureText: true,
              ),
              SizedBox(height: 20),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is AuthLoading) {
                    return CircularProgressIndicator(); // Show loading indicator during sign-up
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
                    child: Text('Sign Up'),
                  );
                },
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signin');
                },
                child: Text('Already have an account? Sign In'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
