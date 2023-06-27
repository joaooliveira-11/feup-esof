import 'package:flutter/material.dart';
import '../screens/appLocalizations.dart';

Container SignInSignUpButton(
    BuildContext context, bool isLogin, Function onTap) {
  final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
  return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
      child: ElevatedButton(
          key: const Key('signInSignUpButtonKey'),
          onPressed: () {
            onTap();
          },
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.pressed)) {
                  return Colors.black26;
                }
                return const Color(0xFF008080);
              }),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)))),
          child: Text(
            isLogin ? appLocalizations.translate("logInUC") ?? "LOG IN" : appLocalizations.translate("signUpUC") ?? "SIGN UP",
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          )
      )
  );
}
