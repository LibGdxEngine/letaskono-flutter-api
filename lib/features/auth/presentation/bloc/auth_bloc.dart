import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/AuthEntity.dart';
import '../../domain/use_cases/sign_in.dart';
import '../../domain/use_cases/sign_up.dart';
import '../../domain/use_cases/confirm_account.dart';
import '../../domain/use_cases/submit_profile.dart';
import '../../../../core/di/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignUp signUpUseCase = sl<SignUp>();
  final SignIn signInUseCase = sl<SignIn>();
  final ConfirmAccount confirmAccountUseCase = sl<ConfirmAccount>();
  final SubmitProfile submitProfileUseCase = sl<SubmitProfile>();

  AuthBloc() : super(AuthInitial()) {
    on<SignUpEvent>((event, emit) async {
      emit(AuthLoading()); // Emit loading state
      try {
        await signUpUseCase.call(
            event.firstName, event.lastName, event.email, event.password);
        emit(AuthConfirmationCodeSent()); // Emit success state
      } catch (error) {
        if (error.toString() == "User already exists") {
          emit(AuthConfirmationCodeSent()); // Emit success state
        } else {
          emit(AuthFailure(
              error.toString())); // Emit failure state with error message
        }
      }
    });

    on<ConfirmCodeEvent>((event, emit) async {
      emit(AuthLoading()); // Emit loading state
      try {
        await confirmAccountUseCase.call(event.code);
        emit(AuthProfileSetup()); // Emit success state
      } catch (error) {
        emit(AuthFailure(
            error.toString())); // Emit failure state with error message
      }
    });

    on<SignInEvent>((event, emit) async {
      emit(AuthLoading()); // Emit loading state
      try {
        // Handle sign in logic
        String token = await signInUseCase.call(event.email, event.password);

        // Save the token locally
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('authToken', token);

        emit(AuthSuccess()); // Emit success state
      } catch (error) {
        emit(AuthFailure(
            error.toString())); // Emit failure state with error message
      }
    });

    on<SubmitProfileEvent>((event, emit) async {
      emit(AuthLoading()); // Emit loading state
      try {
        await submitProfileUseCase.call(event.userProfile);
        emit(AuthConfirmationCodeSent()); // Emit success state
      } catch (error) {
        emit(AuthFailure(
            error.toString())); // Emit failure state with error message
      }
    });
  }
}
