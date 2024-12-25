import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:letaskono_flutter/features/auth/presentation/pages/confirm_account_page.dart';
import 'package:letaskono_flutter/features/auth/presentation/pages/profile_setup_page.dart';
import 'package:letaskono_flutter/features/auth/presentation/pages/reset_password_page.dart';
import 'package:letaskono_flutter/features/auth/presentation/pages/sign_in_page.dart';
import 'package:letaskono_flutter/features/auth/presentation/pages/sign_up_page.dart';
import 'package:letaskono_flutter/features/auth/presentation/pages/welcome_page.dart';
import 'package:letaskono_flutter/features/chat/presentation/pages/chat_list_main.dart';
import 'package:letaskono_flutter/features/chat/presentation/pages/chat_main.dart';
import 'package:letaskono_flutter/features/chat/presentation/pages/khetba_main.dart';
import 'package:letaskono_flutter/features/notifications/presentation/pages/notifications_page.dart';
import 'package:letaskono_flutter/features/splash_page.dart';
import 'package:letaskono_flutter/features/main_page.dart';

import '../features/users/presentation/pages/detail_page.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const WelcomePage());
      case '/confirm':
        final args = settings.arguments as Map<String, String>;
        return MaterialPageRoute(
          builder: (context) => ConfirmCodePage(
            email: args['email'] ?? '',
            password: args['password'] ?? '',
          ),
        );
      case '/chat_list':
        return MaterialPageRoute(builder: (context) => const ChatListMain());
      case '/chat':
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) => ChatMain(
                  currentUserState: args["currentUserState"] as String?,
                  otherUserState: args["otherUserState"] as String?,
                  currentMessageCount: args["currentMessageCount"] as int?,
                  roomId: args["roomId"] as int?,
                  senderId: args['senderId'] as int?,
                  receiverId: args['receiverId'] as int?,
                ));
      case '/khetba':
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) => KhetpaMain(roomId: args["roomId"] as int?));
      case '/profileSetup':
        return MaterialPageRoute(builder: (_) => const ProfileSetupPage());
      case '/notifications':
        return MaterialPageRoute(builder: (_) => const NotificationsPage());
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
