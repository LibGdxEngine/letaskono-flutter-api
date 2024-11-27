part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class SignInEvent extends AuthEvent {
  final String email;
  final String password;

  SignInEvent(this.email, this.password);
}

class SignUpEvent extends AuthEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String password;

  SignUpEvent(this.firstName, this.lastName, this.email, this.password);
}

class ConfirmCodeEvent extends AuthEvent {
  final String code;

  ConfirmCodeEvent(this.code);
}

class SubmitProfileEvent extends AuthEvent {
  final ProfileCompletion profileCompletion;

  SubmitProfileEvent(this.profileCompletion);
}
