import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:letaskono_flutter/features/chat/presentation/pages/khetba_page.dart';

import '../bloc/chat_bloc.dart';

class KhetpaMain extends StatefulWidget {
  final roomId;

  const KhetpaMain({super.key, required this.roomId});

  @override
  State<KhetpaMain> createState() => _KhetpaMainState();
}

class _KhetpaMainState extends State<KhetpaMain> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) =>
            WebSocketBloc()..add(EnterKhetbaPage(widget.roomId!)),
        child: KhetbaPage());
  }
}
