import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:letaskono_flutter/core/utils/ExpandingCircleProgress.dart';

import '../../domain/enitity/Heart.dart';
import '../bloc/chat_bloc.dart';
import '../widgets/HeartPainter.dart';

class KhetbaPage extends StatefulWidget {
  const KhetbaPage({super.key});

  @override
  State<KhetbaPage> createState() => _KhetbaPageState();
}

class _KhetbaPageState extends State<KhetbaPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  List<Heart> hearts = [];
  List<Color> customColors = [
    const Color(0x404B164C),
    const Color(0x40DD88CF),
    const Color(0x40F8E7F6),
  ];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    // Generate random hearts
    for (int i = 0; i < 50; i++) {
      hearts.add(
        Heart(
          position: Offset(
            Random().nextDouble() * 400,
            Random().nextDouble() * 800,
          ),
          size: Random().nextDouble() * 30 + 10,
          velocity: Offset(
            Random().nextDouble() * 2 - 1,
            Random().nextDouble() * 2 - 1,
          ),
          color: customColors[Random().nextInt(customColors.length)],
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final Uri _url = Uri.parse('https://flutter.dev');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text('مرحلة الرؤية الشرعية'),
      ),
      body: BlocConsumer<WebSocketBloc, WebSocketState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is KhetbaStageEntered) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return CustomPaint(
                    painter: HeartPainter(hearts),
                    size: Size(double.infinity, double.infinity),
                    child: Container(
                      width: screenWidth,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              'تهانينا لكما',
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              textAlign: TextAlign.center,
                              'لقد وصلتما الان إلى مرحلة الرؤية الشرعية حيث يجب على العريس الاتصال بولي أمر العروس خلال 48 ساعة فقط',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              textAlign: TextAlign.center,
                              'اسم العريس: ${state.room.maleSummary?.firstName} ${state.room.maleSummary?.lastName}',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              textAlign: TextAlign.center,
                              'اسم العروس: ${state.room.femaleSummary?.firstName} ${state.room.femaleSummary?.lastName}',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              textAlign: TextAlign.center,
                              'للتواصل مع ولي الأمر',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            GestureDetector(
                              onTap: () {
                              },
                              child: SelectableText(
                                textAlign: TextAlign.center,
                                '${state.room.femaleSummary?.fatherRelatedInfo}',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ]),
                    ),
                  );
                },
              ),
            );
          }
          return ExpandingCircleProgress();
        },
      ),
    );
  }
}
