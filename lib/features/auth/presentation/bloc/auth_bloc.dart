import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:letaskono_flutter/core/di/injection_container.dart';
import 'package:letaskono_flutter/features/auth/data/errors/SignUpException.dart';
import 'package:letaskono_flutter/features/auth/domain/entities/ProfileSetupEntity.dart';
import '../../domain/use_cases/password_reset.dart';
import '../../domain/use_cases/password_verify.dart';
import '../../domain/use_cases/resend_activation_code.dart';
import '../../domain/use_cases/sign_in.dart';
import '../../domain/use_cases/sign_up.dart';
import '../../domain/use_cases/confirm_account.dart';
import '../../domain/use_cases/submit_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SharedPreferences prefs = sl<SharedPreferences>();
  final SignUp signUpUseCase = sl<SignUp>();
  final SignIn signInUseCase = sl<SignIn>();
  final ConfirmAccount confirmAccountUseCase = sl<ConfirmAccount>();
  final CompleteProfile submitProfileUseCase = sl<CompleteProfile>();
  final PasswordReset passwordResetUseCase = sl<PasswordReset>();
  final PasswordVerify passwordVerifyUseCase = sl<PasswordVerify>();
  final ResendActivationCode resendActivationCodeUseCase = sl<ResendActivationCode>();

  AuthBloc() : super(AuthInitial()) {

    on<ResendActivationCodeEvent>((event, emit) async {
      emit(AuthLoading());
      try{
        final response = await resendActivationCodeUseCase(event.email);
        emit(ActivationEmailResent());
      }catch (error){
        emit(ResendingActivationFailed(error.toString()));
      }
    });

    on<SignUpEvent>((event, emit) async {
      emit(AuthLoading()); // Emit loading state
      try {
        await signUpUseCase.call(
            event.firstName, event.lastName, event.email, event.password);
        emit(AuthConfirmationCodeSent()); // Emit success state
      } on SignupException catch (error) {
        if (error.isEmailConfirmed) {
          emit(AuthFailure(
              error.toString())); // Emit failure state with error message
        } else if(error.isEmailConfirmed == false) {
          emit(
              AuthConfirmationCodeSent()); // go to confirmation code sent state
        }else{
          emit(AuthFailure(error.message));
        }
      } on Exception catch (error) {
        emit(AuthFailure(error.toString()));
      }
    });

    on<ConfirmCodeEvent>((event, emit) async {
      emit(AuthLoading()); // Emit loading state
      try {
        await confirmAccountUseCase.call(event.code);
        emit(AuthProfileSetup()); // Emit success state
      } catch (error) {
        emit(AuthFailure(error.toString()));
      }
    });

    on<SignInEvent>((event, emit) async {
      emit(AuthLoading()); // Emit loading state
      try {
        // Handle sign in logic
        String token = await signInUseCase.call(event.email, event.password);
        await prefs.setString('auth_token', token);

        emit(AuthSuccess()); // Emit success state
      } catch (error) {
        emit(AuthFailure(
            error.toString())); // Emit failure state with error message
      }
    });

    on<SubmitProfileEvent>((event, emit) async {
      emit(AuthLoading()); // Emit loading state
      try {
        await submitProfileUseCase.call(event.profileCompletion);
        emit(AuthProfileSubmitted()); // Emit success state
      } catch (error) {
        emit(AuthFailure(
            error.toString())); // Emit failure state with error message
      }
    });

    on<PasswordResetEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        await passwordResetUseCase(event.code);
        emit(AuthPasswordResetEmailSent()); // Emit success state
      } catch (error) {
        emit(AuthFailure(
            error.toString())); // Emit failure state with error message
      }
    });

    on<PasswordVerifyEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        await passwordVerifyUseCase(event.code, event.newPassword);
        emit(AuthPasswordVerified()); // Emit success state
      } catch (error) {
        emit(AuthFailure(
            error.toString())); // Emit failure state with error message
      }
    });
  }
}
