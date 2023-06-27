import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:porto_explorer/reusable_widgets/reusable_widget.dart';
import 'package:porto_explorer/screens/home_screen.dart';
import 'package:porto_explorer/screens/signUp_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:porto_explorer/screens/appLocalizations.dart';
import 'package:porto_explorer/reusable_widgets/authButton.dart';

import '../reusable_widgets/popUpWidget.dart';


class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController passwordTextController = TextEditingController();
  final TextEditingController emailTextController = TextEditingController();
  bool passwordIncorrect = false;
  bool userNotFound = false;
  late SharedPreferences preferences;
  String selectedLanguage = 'en';

  @override
  void initState() {
    super.initState();
    initializePreferences();
  }

  void errorState() {
    setState(() {
      passwordIncorrect = false;
    });
  }

  void userNotFoundState() {
    setState(() {
      userNotFound = false;
    });
  }

  Widget buildWrongPasswordPopup(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    return CustomPopup(
      key: const Key('wrongPasswordPopupKey'),
      title: appLocalizations.translate("incorrectPassword") ?? "Incorrect Password",
      message: appLocalizations.translate("incorrectPasswordMessage") ?? "Incorrect Password",
      onPrimaryButtonPressed: errorState,
      primaryButtonText: 'OK',
      onSecondaryButtonPressed: () {  },
    );
  }


  Widget userNotFoundPopup(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    return CustomPopup(
      key: const Key('userNotFoundPopupKey'),
      title: appLocalizations.translate("userNotFound") ?? "User Not Found",
      message: appLocalizations.translate("userNotFoundMessage") ?? "User Not Found",
      onPrimaryButtonPressed: userNotFoundState,
      primaryButtonText: 'OK',
      showSecondaryButton: true,
      onSecondaryButtonPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SignUpScreen(),
          ),
        );
      },
      secondaryButtonText: appLocalizations.translate("singUp") ?? "Sign Up",
    );
  }

  Future<void> initializePreferences() async {
    preferences = await SharedPreferences.getInstance();
    String? storedLanguage = preferences.getString('language');
    if (storedLanguage != null) {
      setState(() {
        selectedLanguage = storedLanguage;
      });
    }
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    await appLocalizations.updateLanguage(selectedLanguage);
  }

  void changeLanguage(String newLanguage) async {
    setState(() {
      selectedLanguage = newLanguage;
    });
    await preferences.setString('language', newLanguage);
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    await appLocalizations.updateLanguage(selectedLanguage);
  }


  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return KeyedSubtree(
      key: const Key('signInPageKey'),
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: const Color(0xFFF9F9F9),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    20,
                    MediaQuery.of(context).size.height * 0.10,
                    20,
                    0,
                  ),
                  child: Column(
                    children: <Widget>[
                      logoWidget("assets/images/logo.png"),
                      const SizedBox(height: 20),
                      Container(
                        key: const Key('emailFieldKey'),
                        width: 300,
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Color(0xFF008080),
                              width: 1.6,
                            ),
                          ),
                        ),
                        child: reusableTextField(
                          appLocalizations.translate("email") ?? "email",
                          Icons.person_outline,
                          false,
                          emailTextController,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        key: const Key('passwordFieldKey'),
                        width: 300,
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Color(0xFF008080),
                              width: 1.6,
                            ),
                          ),
                        ),
                        child: reusableTextField(
                          appLocalizations.translate("password") ?? "password",
                          Icons.lock_outline,
                          true,
                          passwordTextController,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: 150,
                        child: SignInSignUpButton(context, true, () {
                          FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                            email: emailTextController.text,
                            password: passwordTextController.text,
                          )
                              .then((value) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomeScreen(),
                              ),
                            );
                          }).catchError((error) {
                            setState(() {
                              if (error.code == 'wrong-password') {
                                passwordIncorrect = true;
                              } else if (error.code == 'user-not-found') {
                                userNotFound = true;
                              }
                            });
                          });
                        }),
                      ),
                      signUpOption(),
                    ],
                  ),
                ),
              ),
            ),
            if (passwordIncorrect) buildWrongPasswordPopup(context),
            if (userNotFound) userNotFoundPopup(context),
            Positioned(
              top: 16,
              right: 16,
              child: DropdownButton<String>(
                value: selectedLanguage,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    changeLanguage(newValue);
                  }
                },
                items: const [
                  DropdownMenuItem(
                    value: 'en',
                    child: Text('EN'),
                  ),
                  DropdownMenuItem(
                    value: 'pt',
                    child: Text('PT'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Row signUpOption() {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          appLocalizations.translate("dontHaveAnAccount") ?? "Don't have an account?",
          style: TextStyle(
            color: const Color(0xFF989595).withOpacity(0.9),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SignUpScreen()),
            );
          },
          child: Text(
            appLocalizations.translate("signUp") ?? "Sign Up",
            style: TextStyle(
              color: const Color(0xFF989595).withOpacity(0.9),
            ),
            key: const Key('signUpText'),
          ),
        ),
      ],
    );
  }
}