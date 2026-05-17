import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onLeadingPressed;
  final Widget? leading;
  final bool showProfile;

  const AppHeader({
    super.key,
    this.onLeadingPressed,
    this.leading,
    this.showProfile = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: leading ?? (onLeadingPressed != null 
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black87, size: 32),
              onPressed: onLeadingPressed,
            )
          : null),
      title: Image.asset('assets/pato_logo.png', height: 60),
      centerTitle: true,
      actions: [
        if (showProfile)
          IconButton(
            icon: const Icon(
              Icons.account_circle_outlined,
              color: Colors.black87,
              size: 40,
            ),
            onPressed: () {
              // Navegar para perfil
            },
          ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
