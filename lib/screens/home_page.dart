import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:prof_blog_app/main.dart';
import 'package:prof_blog_app/providers/auth_provider.dart';
import 'package:prof_blog_app/providers/text_form_field.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textFormProvider = Provider.of<TextFormFieldProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      backgroundColor: Colors.deepOrange,
      body: Center(
        child: RaisedButton(
          child: Text('Sign Out'),
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            textFormProvider.makeSignUpFalse();
            authProvider.makeLoadingFalse();
            authProvider.nullifyAll();
            Navigator.of(context).pushReplacementNamed(MyApp.routeToSignInPage);
          },
        ),
      ),
    );
  }
}
