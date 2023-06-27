import 'package:flutter/material.dart';

Image logoWidget(String imageName) {
  return Image.asset(
    imageName,
    fit: BoxFit.fitWidth,
    width: 240,
    height: 240,
  );
}

TextField reusableTextField(
    String text,
    IconData icon,
    bool isPasswordType,
    TextEditingController controller,
    ) {
  return TextField(
    controller: controller,
    obscureText: isPasswordType,
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    cursorColor: Colors.white,
    style: TextStyle(
      color: const Color(0xFF989595).withOpacity(0.9),
    ),
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color: const Color(0xFF008080),
      ),
      labelText: text,
      labelStyle: TextStyle(
        color: const Color(0xFF989595).withOpacity(0.9),
      ),
      filled: true,
      fillColor: const Color(0xFFF9F9F9),
      contentPadding:
      const EdgeInsets.only(left: 10, bottom: 10, top: 10, right: 10),
    ),
    keyboardType: isPasswordType
        ? TextInputType.visiblePassword
        : TextInputType.emailAddress,
  );
}

Widget tagButton({
  required String text,
  required String value,
  required IconData iconData,
}) {
  return Column(
    children: [
      CircleAvatar(
        backgroundColor: const Color(0xFF008080).withOpacity(0.2),
        child: Icon(
          iconData,
          color: const Color(0xFF008080),
          size: 20.0,
        ),
      ),
      Text(
        text,
        style: TextStyle(
          color: const Color(0xFF008080).withOpacity(0.6),
          fontWeight: FontWeight.w400,
        ),
      ),
      Text(
        value,
        style: const TextStyle(
          fontWeight: FontWeight.w800,
        ),
      ),
    ],
  );
}