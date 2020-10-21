import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:prof_blog_app/main.dart';
import 'package:prof_blog_app/models/user_model.dart';
import 'package:prof_blog_app/providers/auth_provider.dart';
import 'package:prof_blog_app/providers/text_form_field.dart';
import 'package:prof_blog_app/services/firebase_auth.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class SignUpPage extends StatefulWidget {
  BuildContext context;

  AnimationController textController;
  SignUpPage(this.context, this.textController);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  FocusNode emailNode;
  AuthService _authService = AuthService();

  FocusNode passNode1;
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  FocusNode passNode2;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailNode = FocusNode();
    passNode1 = FocusNode();
    passNode2 = FocusNode();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailNode.dispose();
    passNode1.dispose();
    passNode2.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final textFormProvider = Provider.of<TextFormFieldProvider>(context);
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.3,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          children: [
            SlideTransition(
              position:
                  Tween<Offset>(begin: Offset(-3, 0), end: Offset.zero).animate(
                CurvedAnimation(
                  parent: widget.textController,
                  curve: Curves.elasticOut,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 25,
                  right: 25,
                  top: 50,
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Color(0xFFedebe6),
                            borderRadius: BorderRadius.circular(20)),
                        child: TextFormField(
                          textCapitalization: TextCapitalization.sentences,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(emailNode);
                          },
                          onChanged: (value) {
                            authProvider.setFullName(value);
                          },
                          cursorColor: Colors.black,
                          autofocus: false,
                          decoration: InputDecoration(
                              hintText: 'Full Name',
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.only(left: 12),
                              hintStyle: TextStyle()),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Color(0xFFedebe6),
                            borderRadius: BorderRadius.circular(20)),
                        child: TextFormField(
                          onChanged: (value) {
                            authProvider.setEmail(value);
                          },
                          focusNode: emailNode,
                          onFieldSubmitted: (_) {
                            emailNode.unfocus();
                            FocusScope.of(context).requestFocus(passNode1);
                          },
                          autofocus: false,
                          textInputAction: TextInputAction.next,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                              hintText: 'Email',
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.only(left: 12),
                              hintStyle: TextStyle()),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Color(0xFFedebe6),
                            borderRadius: BorderRadius.circular(20)),
                        child: Stack(
                          alignment: Alignment(1.0, 0.0),
                          children: [
                            TextFormField(
                              focusNode: passNode1,
                              onChanged: (value) {
                                authProvider.setFirstPassword(value);
                              },
                              onFieldSubmitted: (_) {
                                passNode1.unfocus();
                                FocusScope.of(context).requestFocus(passNode2);
                              },
                              obscureText:
                                  authProvider.isPasswordShowing ? false : true,
                              autofocus: false,
                              textInputAction: TextInputAction.next,
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                  hintText: 'Password',
                                  border: InputBorder.none,
                                  contentPadding:
                                      const EdgeInsets.only(left: 12),
                                  hintStyle: TextStyle()),
                            ),
                            IconButton(
                              icon: Icon(
                                authProvider.isPasswordShowing
                                    ? Icons.lock
                                    : Icons.lock_open,
                              ),
                              iconSize: 20,
                              onPressed: () {
                                authProvider.togglePasswordShowing();
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Color(0xFFedebe6),
                            borderRadius: BorderRadius.circular(20)),
                        child: Stack(
                          alignment: Alignment(1.0, 0.0),
                          children: [
                            TextFormField(
                              obscureText:
                                  authProvider.isPasswordShowing ? false : true,
                              onChanged: (value) {
                                authProvider.setConfirmPassword(value);
                              },
                              focusNode: passNode2,
                              autofocus: false,
                              textInputAction: TextInputAction.done,
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                  hintText: 'Confirm Password',
                                  border: InputBorder.none,
                                  contentPadding:
                                      const EdgeInsets.only(left: 12),
                                  hintStyle: TextStyle()),
                            ),
                            IconButton(
                              icon: Icon(
                                authProvider.isPasswordShowing
                                    ? Icons.lock
                                    : Icons.lock_open,
                              ),
                              iconSize: 20,
                              onPressed: () {
                                authProvider.togglePasswordShowing();
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SlideTransition(
              position:
                  Tween<Offset>(begin: Offset(0, 4), end: Offset.zero).animate(
                CurvedAnimation(
                  parent: widget.textController,
                  curve: Curves.elasticOut,
                ),
              ),
              child: authProvider.isRegisterInProgress
                  ? JumpingDotsProgressIndicator(
                      fontSize: 40,
                    )
                  : RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          'REGISTER',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Micole',
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      color: Color(0xFF0d1212),
                      onPressed: () async {
                        print(authProvider.email);
                        if (authProvider.fullName == null ||
                            authProvider.email == null ||
                            authProvider.firstPassword == null ||
                            authProvider.confirmPassword == null) {
                          showSnackBar('Any field should not be empty!');
                          return;
                        }

                        if (!isValidEmail(authProvider.email)) {
                          showSnackBar('Invalid Email Address!');
                          return;
                        }
                        if (authProvider.firstPassword !=
                            authProvider.confirmPassword) {
                          showSnackBar('Password doesnt match!');
                          return;
                        }

                        if (formKey.currentState.validate()) {
                          authProvider.toggleRegisterProgress();

                          try {
                            User user = await _authService.createNewUser(
                              UserModel(
                                userId: Uuid().v4(),
                                email: authProvider.email,
                                password: authProvider.confirmPassword,
                                userName: authProvider.fullName,
                              ),
                            );
                            if (user != null) {
                              Navigator.of(context)
                                  .pushReplacementNamed(MyApp.routeToHomePage);
                            }
                          } catch (e) {
                            authProvider.makeLoadingFalse();
                            Fluttertoast.showToast(
                              msg: e.toString(),
                              gravity: ToastGravity.BOTTOM,
                              toastLength: Toast.LENGTH_LONG,
                            );
                          }
                        }
                        ;
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  bool isValidEmail(value) {
    bool emailValid;
    if (value != null) {
      emailValid = RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(value);
    }
    return emailValid;
  }

  showSnackBar(value) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value,
              textAlign: TextAlign.center,
            ),
            Icon(
              Icons.warning,
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
