import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:letaskono_flutter/app/bloc_observer.dart';
import 'package:letaskono_flutter/app/router.dart';
import 'package:letaskono_flutter/core/di/injection_container.dart' as di;
import 'package:letaskono_flutter/features/auth/presentation/bloc/auth_bloc.dart';

void main() async {
  Bloc.observer = AppBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await di.init(); // Initialize Dependency Injection
  runApp(IslamicDatingApp());
}

class IslamicDatingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: MaterialApp(
        title: 'Islamic Dating App',
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}
