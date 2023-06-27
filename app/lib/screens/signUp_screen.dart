import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:porto_explorer/reusable_widgets/reusable_widget.dart';
import 'package:porto_explorer/screens/signIn_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:porto_explorer/screens/appLocalizations.dart';
import 'package:porto_explorer/reusable_widgets/authButton.dart';

import '../reusable_widgets/popUpWidget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController passwordTextController = TextEditingController();
  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController confirmPasswordTextController =
      TextEditingController();
  final TextEditingController usernameTextController = TextEditingController();
  final TextEditingController nameTextController = TextEditingController();
  bool emailAlreadyInUse = false;
  bool passwordsDoNotMatch = false;

  void emailAlreadyInUseState() {
    setState(() {
      emailAlreadyInUse = false;
    });
  }

  void passwordsDoNotMatchState() {
    setState(() {
      passwordsDoNotMatch = false;
    });
  }

  Widget emailAlreadyInUsePopup(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    return CustomPopup(
      key: const Key('emailAlreadyInUsePopup'),
      title: appLocalizations.translate("emailInUse") ?? "Email Already in Use",
      message: appLocalizations.translate("emailInUseMessage") ??
          "The email you entered is already registered. Please sign in or use a different email.",
      onPrimaryButtonPressed: emailAlreadyInUseState,
      primaryButtonText: 'OK',
      onSecondaryButtonPressed: () {},
    );
  }

  Widget passwordsDoNotMatchPopup(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    return CustomPopup(
      key: const Key('passwordsDoNotMatchPopup'),
      title: appLocalizations.translate("passwordDoNotMatch") ??
          "Passwords Do Not Match",
      message: appLocalizations.translate("passwordDoNotMatchMessage") ??
          "The passwords you entered do not match. Please try again.",
      onPrimaryButtonPressed: passwordsDoNotMatchState,
      primaryButtonText: 'OK',
      onSecondaryButtonPressed: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return Scaffold(
      key: const Key('signUpPageKey'),
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: const Color(0xFFF9F9F9),
            // Set the desired background color here
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  20,
                  MediaQuery.of(context).size.height * 0.005,
                  20,
                  0,
                ),
                child: Column(
                  children: <Widget>[
                    logoWidget("assets/images/logo.png"),
                    Container(
                      key: const Key('nameFieldKey'),
                      width: 300,
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom:
                              BorderSide(color: Color(0xFF008080), width: 2.0),
                        ),
                      ),
                      child: reusableTextField(
                        appLocalizations.translate("name") ?? "Name",
                        Icons.person,
                        false,
                        nameTextController,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      key: const Key('usernameFieldKey'),
                      width: 300,
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom:
                              BorderSide(color: Color(0xFF008080), width: 2.0),
                        ),
                      ),
                      child: reusableTextField(
                        appLocalizations.translate("username") ?? "Username",
                        Icons.person,
                        false,
                        usernameTextController,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      key: const Key('emailSignupFieldKey'),
                      width: 300,
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom:
                              BorderSide(color: Color(0xFF008080), width: 2.0),
                        ),
                      ),
                      child: reusableTextField(
                        appLocalizations.translate("email") ?? "Email",
                        Icons.person_outline,
                        false,
                        emailTextController,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      key: const Key('passwordTextField'),
                      width: 300,
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom:
                              BorderSide(color: Color(0xFF008080), width: 2.0),
                        ),
                      ),
                      child: reusableTextField(
                        appLocalizations.translate("password") ?? "Password",
                        Icons.lock_outlined,
                        true,
                        passwordTextController,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      key: const Key('confirmPasswordTextField'),
                      width: 300,
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom:
                              BorderSide(color: Color(0xFF008080), width: 2.0),
                        ),
                      ),
                      child: reusableTextField(
                        appLocalizations.translate("confirm password") ??
                            "Confirm Password",
                        Icons.lock_outlined,
                        true,
                        confirmPasswordTextController,
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: 150,
                      child: SignInSignUpButton(context, false, signUp),
                    ),
                    signInOption(),
                  ],
                ),
              ),
            ),
          ),
          if (emailAlreadyInUse) emailAlreadyInUsePopup(context),
          if (passwordsDoNotMatch) passwordsDoNotMatchPopup(context),
        ],
      ),
    );
  }

  Row signInOption() {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          appLocalizations.translate("Already have an account?") ??
              "Already have an account?",
          style: TextStyle(color: const Color(0xFF989595).withOpacity(0.9)),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SignInScreen()),
            );
          },
          child: Text(
            appLocalizations.translate("singIn") ?? "Sign In",
            style: TextStyle(color: const Color(0xFF989595).withOpacity(0.9)),
          ),
        )
      ],
    );
  }

  bool passwordConfirmed() {
    if (passwordTextController.text.trim() ==
        confirmPasswordTextController.text.trim()) {
      return true;
    }
    return false;
  }

  Future<void> signUp() async {
    if (passwordConfirmed()) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailTextController.text,
          password: passwordTextController.text,
        );
        FirebaseFirestore firestore = FirebaseFirestore.instance;

        await firestore.collection('users').doc(userCredential.user!.uid).set({
          'name': nameTextController.text,
          'username': usernameTextController.text,
          'email': emailTextController.text,
          'score': 0,
          'nrVisitedPoints': 0,
        });

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SignInScreen()),
        );
      } catch (error) {
        if (error is FirebaseAuthException &&
            error.code == 'email-already-in-use') {
          setState(() {
            emailAlreadyInUse = true;
          });
        }
      }
    } else {
      setState(() {
        passwordsDoNotMatch = true;
      });
    }
  }
}
