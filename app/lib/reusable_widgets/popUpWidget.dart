import 'package:flutter/material.dart';
import '../screens/appLocalizations.dart';


class CustomPopup extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onPrimaryButtonPressed;
  final String primaryButtonText;
  final bool showSecondaryButton;
  final VoidCallback onSecondaryButtonPressed;
  final String secondaryButtonText;

  const CustomPopup({
    Key? key,
    required this.title,
    required this.message,
    required this.onPrimaryButtonPressed,
    required this.primaryButtonText,
    this.showSecondaryButton = false,
    required this.onSecondaryButtonPressed,
    this.secondaryButtonText = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    return KeyedSubtree(
      key: key,
      child: Stack(
        children: [
          Container(
            color: Colors.black54,
            width: double.infinity,
            height: double.infinity,
          ),
          Center(
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: const Color(0xFF008080),
                            ),
                            child: TextButton(
                              onPressed: onPrimaryButtonPressed,
                              child: Text(
                                primaryButtonText,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (showSecondaryButton) ...[
                          const SizedBox(width: 10.0),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: const Color(0xFF008080),
                              ),
                              child: TextButton(
                                onPressed: onSecondaryButtonPressed,
                                child: Text(
                                  secondaryButtonText,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}