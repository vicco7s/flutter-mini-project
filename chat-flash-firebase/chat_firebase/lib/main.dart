import 'package:chat_firebase/Screen/chat_screen.dart';
import 'package:chat_firebase/Screen/login_screen.dart';
import 'package:chat_firebase/Screen/registration_screen.dart';
import 'package:chat_firebase/Screen/welcome_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
          textTheme: TextTheme(bodyText1: TextStyle(color: Colors.black))),
      initialRoute: WelcomeScreen.id,
      routes: {
        
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id : (context) => LoginScreen(),
        RegistrationScreen.id : (context) => RegistrationScreen(),
        ChatScreen.id : (context) => ChatScreen(),
      },
    );
  }
}
