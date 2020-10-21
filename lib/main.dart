import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prof_blog_app/providers/auth_provider.dart';
import 'package:prof_blog_app/providers/text_form_field.dart';
import 'package:prof_blog_app/screens/authenticate/wrapper.dart';
import 'package:prof_blog_app/screens/home_page.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(MyApp());
}

const MaterialColor swatch = const MaterialColor(
  0xFF0d1212,
  const <int, Color>{
    50: const Color(0xFF0d1212),
    100: const Color(0xFF0d1212),
    200: const Color(0xFF0d1212),
    300: const Color(0xFF0d1212),
    400: const Color(0xFF0d1212),
    500: const Color(0xFF0d1212),
    600: const Color(0xFF0d1212),
    700: const Color(0xFF0d1212),
    800: const Color(0xFF0d1212),
    900: const Color(0xFF0d1212),
  },
);

class MyApp extends StatelessWidget {
  static final String routeToHomePage = 'homepage';
  static final String routeToSignInPage = 'signinpage';

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => TextFormFieldProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => AuthProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Atriculo',
        home: MainScreen(),
        theme: ThemeData(
          primarySwatch: swatch,
        ),
        routes: {
          routeToHomePage: (ctx) => HomePage(),
          routeToSignInPage: (ctx) => SignInScreen(),
        },
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return HomePage();
        } else {
          return SignInScreen();
        }
      },
    );
  }
}
