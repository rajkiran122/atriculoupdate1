import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:prof_blog_app/main.dart';
import 'package:prof_blog_app/models/user_model.dart';
import 'package:prof_blog_app/providers/auth_provider.dart';
import 'package:prof_blog_app/services/firebase_auth.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SignInPage extends StatefulWidget {
  BuildContext context;
  AnimationController animationController;
  TickerProvider tickerProvider;
  AnimationController textFieldSignUpController;
  AnimationController textController;
  SignInPage(this.context, this.animationController, this.textController,
      this.textFieldSignUpController, this.tickerProvider);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  FocusNode focusNodePass1;
  AuthService authService = AuthService();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    focusNodePass1 = FocusNode();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    focusNodePass1.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.36,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.64,
        child: Column(
          children: [
            SlideTransition(
              position: Tween(begin: Offset(-3, 0), end: Offset.zero)
                  .animate(CurvedAnimation(
                parent: widget.textController,
                curve: Curves.elasticOut,
              )),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 25,
                  right: 25,
                  top: 50,
                ),
                child: Form(
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Color(0xFFedebe6),
                            borderRadius: BorderRadius.circular(20)),
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (value) {
                            FocusScope.of(context).requestFocus(focusNodePass1);
                          },
                          cursorColor: Colors.black,
                          autofocus: false,
                          onChanged: (value) {
                            authProvider.setEmail(value);
                          },
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
                              focusNode: focusNodePass1,
                              obscureText:
                                  authProvider.isPasswordShowing ? false : true,
                              onChanged: (value) {
                                authProvider.setConfirmPassword(value);
                              },
                              autofocus: false,
                              textInputAction: TextInputAction.done,
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
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SlideTransition(
              position: Tween<Offset>(begin: Offset(-3, 0), end: Offset.zero)
                  .animate(CurvedAnimation(
                parent: widget.textController,
                curve: Curves.elasticOut,
              )),
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
                          'SIGN IN',
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
                        if (authProvider.email == null ||
                            authProvider.confirmPassword == null) {
                          showSnackbar('Any field should not be empty!');
                          return;
                        }
                        if (!isValidEmail(authProvider.email)) {
                          showSnackbar('Invalid Email Address!');
                          return;
                        }

                        authProvider.toggleRegisterProgress();

                        try {
                          User user = await authService.signInUser(
                            UserModel(
                              email: authProvider.email,
                              password: authProvider.confirmPassword,
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
                      },
                    ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height >= 700 ? 20 : 13,
            ),
            SlideTransition(
              position: Tween(begin: Offset(0, 3), end: Offset.zero).animate(
                  CurvedAnimation(
                      parent: widget.textController, curve: Curves.elasticOut)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: Image.asset(
                        'assets/icons/iconfinder__google_1249992.png'),
                    onPressed: () {},
                    iconSize: 40,
                  ),
                  IconButton(
                    iconSize: 50,
                    icon: Image.asset(
                      'assets/icons/icons8-facebook-400.png',
                      height: 50,
                      width: 50,
                    ),
                    onPressed: () {
                      widget.textController.forward();
                    },
                  ),
                  IconButton(
                    iconSize: 50,
                    icon: Image.asset('assets/icons/icons8-phone-100.png'),
                    onPressed: () {},
                  ),
                ],
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

  showSnackbar(value) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(value),
            Icon(
              Icons.warning,
              color: Colors.red,
            )
          ],
        ),
      ),
    );
  }
}
