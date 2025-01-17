import 'package:flutter/services.dart'; // For rootBundle
import 'dart:ui' as ui; // For using ui.Image
import 'dart:async'; // For Future handling
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:letaskono_flutter/core/utils/CustomButton.dart';
import 'package:letaskono_flutter/core/utils/ExpandingCircleProgress.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/WelcomePainter.dart';
import 'package:flutter/services.dart';

const platform = MethodChannel('com.letaskono.root_checker');

Future<bool> isDeviceRooted() async {
  try {
    final bool isRooted = await platform.invokeMethod('isDeviceRooted');
    return isRooted;
  } catch (e) {
    return false; // Default to false if an error occurs
  }
}

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    Future<ui.Image> loadImage(String assetPath) async {
      final data = await rootBundle.load(assetPath);
      final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
      final frame = await codec.getNextFrame();
      return frame.image;
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).colorScheme.surface,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: SafeArea(
          child: isLoading
              ? Center(child: ExpandingCircleProgress())
              : Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            FutureBuilder<List<ui.Image>>(
                              future: Future.wait([
                                loadImage('assets/images/photo1.png'),
                                loadImage('assets/images/photo3.png'),
                                loadImage('assets/images/wphoto1.png'),
                                loadImage('assets/images/location_icon.png'),
                                loadImage('assets/images/photo2.png'),
                                loadImage(
                                    'assets/images/photo_of_niqab_colored_woman.png'),
                                loadImage('assets/images/wphoto3.png'),
                                loadImage('assets/images/chat_icon.png'),
                              ]),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(
                                    child: ExpandingCircleProgress(),
                                  );
                                }
                                final images = snapshot.data!;
                                return Center(
                                  child: CustomPaint(
                                    size: const Size(331, 336),
                                    painter: WelcomePainter(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      innerColor: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      innerCircleColor:
                                          Theme.of(context).colorScheme.surface,
                                      images: images,
                                      positions: [
                                        const Offset(300, 100),
                                        const Offset(331 / 2, 336 / 2),
                                        const Offset(50, 250),
                                        const Offset(220, 30),
                                        const Offset(60, 60),
                                        const Offset(290, 250),
                                        const Offset(200, 260),
                                        const Offset(120, 310),
                                      ],
                                      sizes: [
                                        50,
                                        70,
                                        60,
                                        35,
                                        40,
                                        45,
                                        40,
                                        35,
                                      ], // Diameters for the images
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 32),
                            Center(
                              child: Text(
                                'لتسكنوا للزواج الإسلامي',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .copyWith(
                                      height: 1.5,
                                      fontWeight: FontWeight.bold,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomButton(
                            text: 'تسجيل الدخول',
                            icon: 'assets/images/signin_icon.png',
                            iconBackgroundColor: Colors.white,
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, '/signin');
                            },
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            textColor: Colors.white,
                          ),
                          const SizedBox(height: 8),
                          CustomButton(
                            text: 'تسجيل حساب جديد',
                            icon: 'assets/images/signup_icon.png',
                            iconBackgroundColor: Colors.white,
                            onPressed: () {
                              Navigator.pushNamed(context, '/signup');
                            },
                            backgroundColor:
                                Theme.of(context).colorScheme.secondary,
                            textColor: Theme.of(context).colorScheme.primary,
                          ),
                          SizedBox(height: 8.h),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final isRooted = await isDeviceRooted();
      if (isRooted) {
        SystemNavigator.pop();
      }
      final _prefs = GetIt.instance<SharedPreferences>();
      // If user already signed In, go to home page directly
      final token = _prefs.getString("auth_token");
      if (token != null) {
        Navigator.pushReplacementNamed(context, "/users");
      } else {
        setState(() {
          isLoading = false;
        });
      }
    });
  }
}
