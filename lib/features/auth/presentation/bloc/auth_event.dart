part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
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
  final AuthEntity userProfile;

  SubmitProfileEvent(this.userProfile);
}
