import 'package:flutter/services.dart'; // For rootBundle
import 'dart:ui' as ui; // For using ui.Image
import 'dart:async'; // For Future handling
import 'package:flutter/material.dart';
import 'package:letaskono_flutter/core/utils/CustomButton.dart';
import 'package:letaskono_flutter/core/utils/ExpandingCircleProgress.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/WelcomePainter.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    Future<ui.Image> loadImage(String assetPath) async {
      final data = await rootBundle.load(assetPath);
      final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
      final frame = await codec.getNextFrame();
      return frame.image;
    }

    Future<ui.Image> loadSvg(String svgPath) async {
      final String svgString = await rootBundle.loadString(svgPath);
      final PictureInfo pictureInfo =
          await vg.loadPicture(SvgStringLoader(svgString), null);

      // Convert the SVG to a Picture
      final ui.Image image = await pictureInfo.picture.toImage(35, 35);
      pictureInfo.picture.dispose();
      return image;
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).colorScheme.surface, // Change status bar color here
        statusBarIconBrightness: Brightness.light, // For white icons
      ),
      child: Scaffold(
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  FutureBuilder<List<ui.Image>>(
                      future: Future.wait([
                        loadImage('assets/images/photo1.png'),
                        loadImage('assets/images/photo3.png'),
                        loadImage('assets/images/wphoto1.png'),
                        loadImage('assets/images/location_icon.png'),
                        loadImage('assets/images/photo2.png'),
                        loadImage('assets/images/wphoto2.png'),
                        loadImage('assets/images/wphoto3.png'),
                        loadImage('assets/images/chat_icon.png'),
                      ]),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: Center(child: ExpandingCircleProgress()),
                          );
                        }
                        final images = snapshot.data!;
                        return Center(
                          child: CustomPaint(
                            size: const Size(331, 336),
                            // Set canvas size based on the SVG viewBox
                            painter: WelcomePainter(
                              color: Theme.of(context).colorScheme.secondary,
                              innerColor: Theme.of(context).colorScheme.secondary,
                              innerCircleColor:
                                  Theme.of(context).colorScheme.background,
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
                      }),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      'لتسكنوا للزواج الإسلامي',
                      style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                            height: 1.5,
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 50),
                  CustomButton(
                    text: 'تسجيل الدخول',
                    icon: 'assets/images/signin_icon.png',
                    iconBackgroundColor: Colors.white,
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/signin');
                    },
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    textColor: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  CustomButton(
                    text: 'تسجيل حساب جديد',
                    icon: 'assets/images/signup_icon.png',
                    iconBackgroundColor: Colors.white,
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/signup');
                    },
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    textColor: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
