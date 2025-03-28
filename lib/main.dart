import 'package:aigenda_mobile/screens/home_screen.dart';
import 'package:aigenda_mobile/screens/login_screen.dart';
import 'package:aigenda_mobile/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/firebase/firebase_service.dart';
import 'screens/splash_screen.dart';
import 'services/providers/user_provider.dart';
import 'utils/constants/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.initialize();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: Routes.splash,
        routes: {
          Routes.splash: (context) => const SplashScreen(),
          Routes.login: (context) => const LoginScreen(),
          Routes.register: (context) => const RegisterScreen(),
          Routes.home: (context) => const HomeScreen(),
        },
      ),
    );
  }
}
