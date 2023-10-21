import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:basic_utils/basic_utils.dart';
import '../../../../page/Users/loginpage.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController _email = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // TODO: implement dispose
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        title: Text('Reset Password'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Memasukan email untuk \n mengatur ulang kata sandi Anda",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _email,
                  cursorColor: Colors.white,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    labelText: "Email",
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (email) =>
                      email != null && !EmailValidator.validate(email)
                          ? "masukan Email dengan benar"
                          : null,
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(50),
                  ),
                  icon: const Icon(Icons.email_outlined),
                  label: Text(
                    "Reset Password",
                    style: TextStyle(fontSize: 25),
                  ),
                  onPressed: resetPassword,
                ),
              ],
            )),
      ),
    );
  }

  Future resetPassword() async {
    //loading screen circularprogress
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: CircularProgressIndicator(),
        ));
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _email.text.trim());

      const snackBar = SnackBar(
        backgroundColor: Colors.green,
        content: Text('Password Reset telah dikirim cek email atau spam'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      Navigator.of(context).pushReplacement(
          CupertinoPageRoute(builder: ((context) => const LoginPage())));
    } on FirebaseAuthException catch (e) {
      print(e);
      String message = e.message ?? "An error occurred";
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
      Navigator.pop(context);
    }
  }
}
