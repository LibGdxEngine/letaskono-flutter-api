part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthFailure extends AuthState {
  final String message;

  AuthFailure(this.message);
}

class AuthSuccess extends AuthState {}

class AuthConfirmationCodeSent extends AuthState {}

class AuthProfileSetup extends AuthState {}

class AuthPendingActivation extends AuthState {}

class AuthAuthenticated extends AuthState {}

class AuthProfileSubmitted extends AuthState {}

class AuthPasswordResetEmailSent extends AuthState {}

class AuthPasswordVerified extends AuthState {}

class ActivationEmailResent extends AuthState {

}

class ResendingActivationFailed extends AuthState {
  final String error;

  const ResendingActivationFailed(this.error);

}