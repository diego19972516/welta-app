import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/constants/app_colors.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/register_screen.dart';
import 'features/home/screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  await Supabase.initialize(
    url:          dotenv.env['SUPABASE_URL']!,
    publishableKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(const WeltaApp());
}

class WeltaApp extends StatelessWidget {
  const WeltaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welta',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: WeltaColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: WeltaColors.accent,
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login':    (_) => const LoginScreen(),
        '/register': (_) => const RegisterScreen(),
        '/home': (_) => const HomeScreen(),
      },
    );
  }
}

class HomeTemp extends StatelessWidget {
  const HomeTemp({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    return Scaffold(
      backgroundColor: WeltaColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Icon(Icons.home_repair_service_rounded,
                  color: WeltaColors.accent, size: 36),
                const SizedBox(width: 8),
                Text('Welta',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: WeltaColors.primary,
                  )),
              ]),
              const SizedBox(height: 40),
              Icon(Icons.check_circle_rounded,
                color: WeltaColors.success, size: 64),
              const SizedBox(height: 16),
              Text('¡Bienvenido a Welta!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: WeltaColors.primary,
                )),
              const SizedBox(height: 8),
              Text(user?.email ?? 'Usuario',
                style: TextStyle(
                  fontSize: 16,
                  color: WeltaColors.gray,
                )),
              const SizedBox(height: 8),
              Text('Login funcionando ✅',
                style: TextStyle(
                  fontSize: 14,
                  color: WeltaColors.gray,
                )),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () async {
                    await Supabase.instance.client.auth.signOut();
                    if (context.mounted) {
                      Navigator.pushReplacementNamed(context, '/login');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: WeltaColors.primary,
                    foregroundColor: WeltaColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Cerrar sesión',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}