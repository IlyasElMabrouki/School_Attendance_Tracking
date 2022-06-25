import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/signInScreen.dart';
import 'screens/Sessions.dart';
import 'package:shen/themes/main.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

final theme = ShenTheme.light();

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      title: 'Shen',
      home: Scaffold(
          body: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context,snapshot){
              if (snapshot.hasError){
                return const Center(child: Text('OOPS'));
              }
              else if (snapshot.connectionState == ConnectionState.waiting){
                return const Center(child:CircularProgressIndicator());
              }
              if (snapshot.hasData){
                return Sessions();
              }
              else {
                return SignInScreen();
              }
            },
          )
      ),
    );
  }
}
