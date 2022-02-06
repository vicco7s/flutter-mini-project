import 'package:chat_firebase/Screen/login_screen.dart';
import 'package:chat_firebase/Screen/registration_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = "welcome_screen";
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60.0,
                  ), 
                ),
                Text(
                  'Flash Chat',
                  style: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                    color: Colors.amber
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            Hero(
                tag: 'login',
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Material(
                    elevation: 5.0,
                    color: Colors.lightBlue,
                    borderRadius: BorderRadius.circular(30.0),
                    child: MaterialButton(
                      onPressed: () {
                        Navigator.pushNamed(context, LoginScreen.id);
                      },
                      minWidth: 200.0,
                      height: 42.0,
                      child: Text(
                        'Log In',
                      ),
                    ),
                  ),
                ),
            ),
           Hero(
               tag: 'register',
               child:  Padding(
                 padding: EdgeInsets.symmetric(vertical: 16.0),
                 child: Material(
                   color: Colors.lightBlue,
                   borderRadius: BorderRadius.circular(30.0),
                   elevation: 5.0,
                   child: MaterialButton(
                     onPressed: () {
                       Navigator.pushNamed(context, RegistrationScreen.id);
                     },
                     minWidth: 200.0,
                     height: 42.0,
                     child: Text(
                       'Register',
                     ),
                   ),
                 ),
               ),
           )
          ],
        ),
      ),
    );
  }
}
