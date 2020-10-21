import 'package:flutter/material.dart';
import 'package:prof_blog_app/providers/auth_provider.dart';
import 'package:prof_blog_app/providers/text_form_field.dart';
import 'package:prof_blog_app/screens/authenticate/sign_in_page.dart';
import 'package:prof_blog_app/screens/authenticate/sign_up_page.dart';
import 'package:prof_blog_app/widgets/my_custom_painter.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>
    with TickerProviderStateMixin {
  AnimationController _controller;
  AnimationController _textfieldController;
  AnimationController _textfieldSignUpController;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));

    _textfieldController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1500));
    _textfieldController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1500));
    _textfieldController.forward();
  }

  FocusNode focusNodeEmail = FocusNode();
  FocusNode focusNodePass1 = FocusNode();
  FocusNode focusNodePass2 = FocusNode();

  @override
  void dispose() {
    _controller?.dispose();
    _textfieldController?.dispose();
    _textfieldSignUpController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formProvider = Provider.of<TextFormFieldProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Stack(
        children: [
          CustomPaint(
            child: Container(
              height: MediaQuery.of(context).size.height,
            ),
            painter: MyCustomPainter(_controller.view),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'ATRICULO',
                  style: TextStyle(
                    fontFamily: 'TheNaturelTxt',
                    color: Colors.white,
                    fontSize: 40,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
          formProvider.isSignUpPage
              ? Positioned(
                  top: MediaQuery.of(context).size.height * 0.2,
                  left: MediaQuery.of(context).size.width * 0.13,
                  child: SlideTransition(
                    position:
                        Tween<Offset>(begin: Offset(5, 0), end: Offset.zero)
                            .animate(
                      CurvedAnimation(
                        parent: _textfieldController,
                        curve: Curves.elasticOut,
                      ),
                    ),
                    child: Container(
                      child: Text(
                        'CREATE \nACCOUNT',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Micole',
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    ),
                  ),
                )
              : Positioned(
                  top: MediaQuery.of(context).size.height * 0.25,
                  left: MediaQuery.of(context).size.width * 0.13,
                  child: SlideTransition(
                    position:
                        Tween<Offset>(begin: Offset(5, 0), end: Offset.zero)
                            .animate(
                      CurvedAnimation(
                        parent: _textfieldController,
                        curve: Curves.elasticOut,
                      ),
                    ),
                    child: Container(
                      child: Text(
                        'SIGN IN',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Micole',
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    ),
                  ),
                ),
          formProvider.isSignUpPage
              ? SignUpPage(context, _textfieldController)
              : SignInPage(context, _controller, _textfieldController,
                  _textfieldSignUpController, this),
          formProvider.isSignUpPage
              ? Positioned(
                  bottom: 10,
                  left: 10,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    iconSize: 30,
                    onPressed: () {
                      authProvider.nullifyAll();
                      authProvider.makeLoadingFalse();
                      formProvider.toggleSIGNUP();
                      _controller.reverse();
                      _textfieldController = AnimationController(
                          vsync: this, duration: Duration(milliseconds: 1500));

                      _textfieldController.forward();
                    },
                  ),
                )
              : Positioned(
                  bottom: 10,
                  left: 10,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_forward,
                      color: Colors.black,
                    ),
                    iconSize: 30,
                    onPressed: () {
                      authProvider.nullifyAll();
                      authProvider.makeLoadingFalse();
                      formProvider.toggleSIGNUP();
                      _controller.forward();
                      _textfieldController = AnimationController(
                          vsync: this, duration: Duration(milliseconds: 1500));

                      _textfieldController.forward();
                      print(MediaQuery.of(context).size.height);
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
