import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:letaskono_flutter/app/bloc_observer.dart';
import 'package:letaskono_flutter/app/router.dart';
import 'package:letaskono_flutter/core/di/injection_container.dart' as di;
import 'package:letaskono_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;

void main() async {
  Bloc.observer = AppBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  timeago.setLocaleMessages('ar', timeago.ArMessages());
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // Force portrait mode
  ]);
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
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            snackBarTheme: const SnackBarThemeData(
              backgroundColor: color7895B2,
              // Your desired background color
              contentTextStyle: TextStyle(
                color: colorE8DFCA, // Your desired text color
                fontFamily: 'NotoKufiArabic', // Your desired font family
                fontSize: 16.0, // Your desired font size
              ),
              behavior: SnackBarBehavior.fixed,
              // Optional: for floating SnackBar
              showCloseIcon: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16)), // Optional: rounded corners
              ),
            ),
            appBarTheme: const AppBarTheme(
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: color7895B2,
                statusBarIconBrightness: Brightness.light
              ),
              elevation: 0,
              surfaceTintColor: colorF5EFE6,
              iconTheme: IconThemeData(
                color: color7895B2, // Change the color here
              ),
            ),
            fontFamily: 'NotoKufiArabic',
            colorScheme: const ColorScheme(
              primary: color7895B2,
              // Main app color
              secondary: colorAEBDCA,
              inverseSurface: Color(0xFFDD88CF),

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
            textTheme: const TextTheme(
              headlineSmall: TextStyle(
                  fontSize: 16, // Adjusted for better balance
                  color: fontColor,
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
                  color: color7895B2,
                  letterSpacing: 0,
                  fontFamily: 'NotoKufiArabic'),
              bodyMedium: TextStyle(
                  fontSize: 16,
                  // Ideal for regular body text
                  color: fontColor,
                  fontWeight: FontWeight.w900,
                  height: 1.6,
                  fontFamily: 'NotoKufiArabic'),
              bodyLarge: TextStyle(
                  fontSize: 28,
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
      ),
    );
  }
}
