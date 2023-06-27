import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../screens/appLocalizations.dart';

class KeyedGButton extends GButton {
  KeyedGButton({
    required Key key,
    required IconData icon,
    required String text,
  }) : super(
    key: key,
    icon: icon,
    text: text,
  );
}

class CustomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabChange;
  final PageController pageController;

  const CustomNavBar({
    required this.selectedIndex,
    required this.onTabChange,
    required this.pageController,
  });


  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return GNav(
      gap: 8,
      backgroundColor: Colors.white,
      color: const Color(0xFF008080),
      activeColor: const Color(0xFF008080),
      selectedIndex: selectedIndex,
      onTabChange: (index) {
        onTabChange(index);
        pageController.animateToPage(index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.ease);
      },
      tabs: [
        KeyedGButton(
          key: const Key('homeButtonKey'),
          icon: Icons.home,
          text: appLocalizations.translate("home") ?? "Home",
        ),
        KeyedGButton(
          key: const Key('mapsButtonKey'),
          icon: Icons.location_on,
          text: appLocalizations.translate("maps") ?? "Maps",
        ),
        KeyedGButton(
          key: const Key('profileButtonKey'),
          icon: Icons.account_circle,
          text: appLocalizations.translate("profile") ?? "Profile",
        ),
      ],
    );
  }
}