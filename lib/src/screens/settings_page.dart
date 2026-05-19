import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/app_header.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppHeader(
        showProfile: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface, size: 32),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Configurações',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.settings_outlined, color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Personalize sua experiência',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 32),
            
            _buildSectionTitle(context, 'Geral'),
            _buildSettingsGroup(context, [
              _buildSettingItem(
                context,
                icon: Icons.notifications_none_rounded,
                title: 'Notificações',
                onTap: () {},
              ),
              _buildDivider(context),
              _buildSettingItem(
                context,
                icon: Icons.language_rounded,
                title: 'Idioma',
                trailing: 'Português',
                onTap: () {},
              ),
            ]),
            
            const SizedBox(height: 32),
            _buildSectionTitle(context, 'Acessibilidade'),
            _buildSettingsGroup(context, [
              _buildSwitchItem(
                context,
                icon: Icons.notifications_active_outlined,
                title: 'Modo de foco',
                subtitle: 'Reduz distrações e ilustrações',
                value: settingsProvider.focusMode,
                onChanged: (val) => settingsProvider.toggleFocusMode(val),
              ),
              _buildDivider(context),
              _buildSwitchItem(
                context,
                icon: Icons.text_fields_rounded,
                title: 'Textos maiores',
                value: settingsProvider.largerText,
                onChanged: (val) => settingsProvider.toggleLargerText(val),
              ),
              _buildDivider(context),
              _buildSwitchItem(
                context,
                icon: Icons.visibility_outlined,
                title: 'Alto contraste',
                value: settingsProvider.highContrast,
                onChanged: (val) => settingsProvider.toggleHighContrast(val),
              ),
            ]),
            
            const SizedBox(height: 32),
            _buildSectionTitle(context, 'Outros'),
            _buildSettingsGroup(context, [
              _buildSettingItem(
                context,
                icon: Icons.info_outline,
                title: 'Sobre o Pato',
                onTap: () => Navigator.pushNamed(context, '/about'),
              ),
            ]),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildSettingsGroup(BuildContext context, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.05)),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Divider(height: 1, indent: 50, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.05));
  }

  Widget _buildSettingItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? trailing,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: theme.colorScheme.primary),
      title: Text(
        title,
        style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailing != null)
            Text(
              trailing,
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.4)),
            ),
          const SizedBox(width: 8),
          Icon(Icons.chevron_right, color: theme.colorScheme.onSurface.withValues(alpha: 0.2)),
        ],
      ),
    );
  }

  Widget _buildSwitchItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(icon, color: theme.colorScheme.primary),
      title: Text(
        title,
        style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
      ),
      subtitle: subtitle != null ? Text(subtitle, style: theme.textTheme.bodySmall) : null,
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: theme.colorScheme.primary,
      ),
    );
  }
}
