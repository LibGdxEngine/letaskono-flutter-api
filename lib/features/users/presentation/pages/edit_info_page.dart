import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/user_bloc.dart';
import '../widgets/InfoEditor.dart';

class EditInfoPage extends StatelessWidget {
  const EditInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userBloc = UserBloc()..add(FetchCurrentUserEvent());
    return BlocProvider(
      create: (context) => userBloc,
      child: InfoEditor(userBloc: userBloc),
    );
  }
}
