import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:letaskono_flutter/features/auth/presentation/pages/confirm_account_page.dart';
import 'package:letaskono_flutter/features/auth/presentation/pages/profile_setup_page.dart';
import 'package:letaskono_flutter/features/auth/presentation/pages/reset_password_page.dart';
import 'package:letaskono_flutter/features/auth/presentation/pages/sign_in_page.dart';
import 'package:letaskono_flutter/features/auth/presentation/pages/sign_up_page.dart';
import 'package:letaskono_flutter/features/chat/presentation/pages/chat_main.dart';
import 'package:letaskono_flutter/features/chat/presentation/pages/chat_page.dart';
import 'package:letaskono_flutter/features/splash_page.dart';
import 'package:letaskono_flutter/features/main_page.dart';

import '../features/users/presentation/pages/detail_page.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case '/confirm':
        final args = settings.arguments as Map<String, String>;
        return MaterialPageRoute(
          builder: (context) => ConfirmCodePage(
            email: args['email'] ?? '',
            password: args['password'] ?? '',
          ),
        );
      case '/chat':
        final args = settings.arguments as Map<String, int?>;
        return MaterialPageRoute(
            builder: (context) =>
                ChatMain(roomId: args["roomId"]));
      case '/profileSetup':
        return MaterialPageRoute(builder: (_) => const ProfileSetupPage());
      case '/signin':
        return MaterialPageRoute(builder: (_) => const SignInPage());
      case '/resetPassword':
        return MaterialPageRoute(builder: (_) => ResetPasswordPage());
      case '/signup':
        return MaterialPageRoute(builder: (_) => SignUpPage());
      case '/users':
        return MaterialPageRoute(builder: (_) => const HomePage());
      case '/userDetail':
        final String? userId = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => DetailPage(userId: userId),
        );
      default:
        return MaterialPageRoute(builder: (_) => const SplashPage());
    }
  }
}
