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
import 'package:letaskono_flutter/features/users/presentation/pages/edit_info_page.dart';

import '../features/users/presentation/pages/detail_page.dart';

class AppRouter {
  static Route<dynamic> _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0); // Slide in from the right
        const end = Offset.zero;
        const curve = Curves.ease;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: animation.drive(tween),
            child: child,
          ),
        );
      },
    );
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return _createRoute(const WelcomePage());
      case '/confirm':
        final args = settings.arguments as Map<String, String>;
        return _createRoute(ConfirmCodePage(
          email: args['email'] ?? '',
          password: args['password'] ?? '',
        ));
      case '/chat_list':
        return _createRoute(const ChatListMain());
      case '/edit_info':
        return _createRoute(const EditInfoPage());
      case '/chat':
        final args = settings.arguments as Map<String, dynamic>;
        return _createRoute(ChatMain(
          currentUserState: args["currentUserState"] as String?,
          otherUserState: args["otherUserState"] as String?,
          currentMessageCount: args["currentMessageCount"] as int?,
          roomId: args["roomId"] as int?,
          senderId: args['senderId'] as int?,
          receiverId: args['receiverId'] as int?,
        ));
      case '/khetba':
        final args = settings.arguments as Map<String, dynamic>;
        return _createRoute(KhetpaMain(roomId: args["roomId"] as int?));
      case '/profileSetup':
        return _createRoute(const ProfileSetupPage());
      case '/notifications':
        return _createRoute(const NotificationsPage());
      case '/signin':
        return _createRoute(const SignInPage());
      case '/resetPassword':
        return _createRoute(ResetPasswordPage());
      case '/signup':
        return _createRoute(SignUpPage());
      case '/users':
        return _createRoute(const HomePage());
      case '/userDetail':
        final String? userId = settings.arguments as String?;
        return _createRoute(DetailPage(userId: userId));
      default:
        return _createRoute(const SplashPage());
    }
  }
}
