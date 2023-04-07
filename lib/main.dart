import 'package:flutter/material.dart';
import 'package:jot_down/Home.dart';
import 'package:jot_down/image.dart';

import 'package:jot_down/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final auth=FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
      home:
        StreamBuilder(
          stream: auth.authStateChanges(),
          builder: (BuildContext context,AsyncSnapshot snapshot) {
            if(snapshot.data != null){
              return Home(snapshot.data);
            }
            else{
              return Welcome();
            }

          },


        )
    );
  }
}