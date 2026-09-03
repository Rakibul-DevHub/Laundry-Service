import 'package:drop_n_fresh/app/router/app_router.dart';
import 'package:drop_n_fresh/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(const AppRoot());
}

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  Key _scopeKey = UniqueKey();

  void _resetProviders() {
    setState(() => _scopeKey = UniqueKey());
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      key: _scopeKey,
      overrides: <Override>[
        appRouterProvider.overrideWithValue(appRouter),
        resetAppProvider.overrideWithValue(_resetProviders),
      ],
      child: const App(),
    );
  }
}

final Provider<VoidCallback> resetAppProvider = Provider<VoidCallback>(
  (Ref<VoidCallback> ref) =>
      throw UnimplementedError('resetAppProvider not overridden'),
);
