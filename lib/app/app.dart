import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:letaskono_flutter/app/bloc_observer.dart';
import 'package:letaskono_flutter/app/router.dart';
import 'package:letaskono_flutter/core/di/injection_container.dart' as di;
import 'package:letaskono_flutter/features/auth/presentation/bloc/auth_bloc.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  Bloc.observer = AppBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await di.init(); // Initialize Dependency Injection
  runApp(const IslamicDatingApp());
}

class IslamicDatingApp extends StatelessWidget {
  const IslamicDatingApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color colorF5EFE6 = Color(0xFFF5F5F5); // Light Beige
    const Color colorE8DFCA = Color(0xFFF8E7F6); // Light Cream
    const Color colorAEBDCA = Color(0x50DD88CF); // Soft Blue-Grey
    const Color color7895B2 = Color(0xFF4B164C); // Muted Blue
    const Color fontColor = Color(0xFF22172A); // Muted Blue
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'NotoKufiArabic',
          colorScheme: const ColorScheme(
            primary: color7895B2,
            // Main app color
            secondary: colorAEBDCA,
            inversePrimary: colorE8DFCA,
            // Background color
            surface: colorF5EFE6,
            // Card or surfaces
            onPrimary: Colors.white,
            // Text color on primary
            onSecondary: Colors.black,
            // Text color on background
            onSurface: Colors.black87,
            // Text color on surfaces
            error: Colors.red,
            // Error color
            onError: Colors.white,
            // Text color on error
            brightness: Brightness.light, // Use light mode
          ),
          scaffoldBackgroundColor: colorF5EFE6,
          appBarTheme: const AppBarTheme(
            backgroundColor: color7895B2,
            foregroundColor: Colors.white,
          ),
          textTheme: const TextTheme(
            headlineSmall: TextStyle(
                fontSize: 24, // Adjusted for better balance
                color: color7895B2,
                fontFamily: 'NotoKufiArabic'),
            headlineMedium: TextStyle(
                fontSize: 28, // Slightly smaller for consistency
                color: fontColor,
                fontFamily: 'NotoKufiArabic'),
            headlineLarge: TextStyle(
                fontSize: 40,
                // Adjusted to avoid being too large on smaller screens
                color: fontColor,
                fontFamily: 'NotoKufiArabic'),
            bodySmall: TextStyle(
                fontSize: 14, // Increased for better readability
                color: colorAEBDCA,
                fontFamily: 'NotoKufiArabic'),
            bodyMedium: TextStyle(
                fontSize: 16, // Ideal for regular body text
                color: fontColor,
                fontFamily: 'NotoKufiArabic'),
            bodyLarge: TextStyle(
                fontSize: 18,
                // Adjusted for better emphasis without being too large
                color: fontColor,
                fontFamily: 'NotoKufiArabic'),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: color7895B2, // Button background color
              foregroundColor: Colors.white, // Text color
            ),
          ),
        ),
        locale: const Locale('ar'),
        // Arabic locale
        supportedLocales: const [
          Locale('ar'), // Arabic only
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        title: 'لتسكنوا',
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}
