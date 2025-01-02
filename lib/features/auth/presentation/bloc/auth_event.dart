part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class SignInEvent extends AuthEvent {
  final String email;
  final String password;

  const SignInEvent(this.email, this.password);
}

class SignUpEvent extends AuthEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String password;

  const SignUpEvent(this.firstName, this.lastName, this.email, this.password);
}

class ConfirmCodeEvent extends AuthEvent {
  final String code;

  const ConfirmCodeEvent(this.code);
}

class PasswordResetEvent extends AuthEvent {
  final String code;

  const PasswordResetEvent(this.code);
}

class PasswordVerifyEvent extends AuthEvent {
  final String code;
  final String newPassword;

  PasswordVerifyEvent(this.code, this.newPassword);
}

class ResendPasswordResetEvent extends AuthEvent {
  final String code;

  const ResendPasswordResetEvent(this.code);
}

class PasswordResetVerifyEvent extends AuthEvent {
  final String code;

  const PasswordResetVerifyEvent(this.code);
}

class SubmitProfileEvent extends AuthEvent {
  final ProfileCompletion profileCompletion;

  const SubmitProfileEvent(this.profileCompletion);
}

class ResendActivationCodeEvent extends AuthEvent {
  final String email;

  const ResendActivationCodeEvent(this.email);
}
