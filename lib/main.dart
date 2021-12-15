import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:passworld/screens/AskPin.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:passworld/screens/Intropage.dart';
import 'package:passworld/screens/PassWindow.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Phoenix(child: PassworldApp()));
}

class PassworldApp extends StatefulWidget {
  @override
  _PassworldAppState createState() => _PassworldAppState();
}

class _PassworldAppState extends State<PassworldApp> {
  bool authorised = false;
  Map<String, String> mainValue;

  @override
  void initState() {
    super.initState();
    isAuthenticated();
  }

  @override
  void dispose() {
    super.dispose();
    FirebaseAuth.instance.signOut();
  }

  Future<void> isAuthenticated() async {
    final storage = new FlutterSecureStorage();
    mainValue = await storage.readAll();
    await dotenv.load(fileName: '.env');
    if (mainValue['email'] != null) {
      setState(() {
        authorised = true;
      });
    }
    return;
  }

  VoidCallback authenticate(status) {
    print("AUTHENTICATE!");
    return null;
  }

  @override
  Widget build(BuildContext context) {
    precacheImage(AssetImage('assets/images/confused.jpg'), context);
    precacheImage(AssetImage('assets/images/empty.jpg'), context);
    precacheImage(AssetImage('assets/images/askpin.jpg'), context);
    precacheImage(AssetImage('assets/images/check.png'), context);
    precacheImage(AssetImage('assets/images/pin-code.png'), context);
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => authorised
            ? AskPin(authorised, authenticate, mainValue['email'])
            : IntroPage(),
        '/home': (context) =>
            authorised ? PassWindow() : Navigator.pushNamed(context, '/'),
      },
      theme: ThemeData(
        backgroundColor: Colors.white70,
        primaryColor: Colors.purple,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
