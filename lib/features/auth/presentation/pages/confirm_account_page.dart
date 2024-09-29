import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc.dart';

class ConfirmCodePage extends StatelessWidget {
  final TextEditingController codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Confirm Your Account')),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if(state is AuthProfileSetup){
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Account confirmed, enter your data")),
            );
            Navigator.pushReplacementNamed(context, '/signin');
          }

        },
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: codeController,
                decoration: InputDecoration(
                    hintText: 'Enter Confirmation Code'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Handle code confirmation logic
                  BlocProvider.of<AuthBloc>(context).add(
                      ConfirmCodeEvent(codeController.text)
                  );
                  // Navigator.pushNamed(context, '/profileSetup');
                },
                child: Text('Confirm'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
