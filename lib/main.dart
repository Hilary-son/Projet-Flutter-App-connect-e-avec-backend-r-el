import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/storage/cache_service.dart';
import 'features/auth/presentation/auth_providers.dart';
import 'features/auth/presentation/login_page.dart';
import 'home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheService.init();
  runApp(const ProviderScope(child: App()));
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(authControllerProvider);
    return MaterialApp(
      title: 'Shop & Recipes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.deepOrange, useMaterial3: true),
      home: switch (status) {
        AuthStatus.unknown =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
        AuthStatus.authenticated => const HomePage(),
        AuthStatus.unauthenticated => const LoginPage(),
      },
    );
  }
}
