import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

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
    final theme = Theme.of(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

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
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/profile'),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                child: ClipOval(
                  child: (user?.profileImage?.isNotEmpty ?? false)
                      ? Image.memory(
                          base64Decode(user!.profileImage!),
                          height: 40,
                          width: 40,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => 
                              const Icon(Icons.account_circle, color: Colors.black87, size: 40),
                        )
                      : const Icon(Icons.account_circle, color: Colors.black87, size: 40),
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
