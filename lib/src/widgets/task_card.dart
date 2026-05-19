import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String progressText;
  final double progress;
  final bool isFavorite;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;

  const TaskCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.progressText,
    required this.progress,
    this.isFavorite = false,
    this.onTap,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: 140,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (onFavoriteTap != null)
                      GestureDetector(
                        onTap: onFavoriteTap,
                        child: Icon(
                          isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
                          color: isFavorite ? Colors.amber : Colors.black26,
                          size: 18,
                        ),
                      ),
                  ],
                ),
                const Spacer(),
                Center(
                  child: _buildProgressCircle(colorScheme.primary),
                ),
                const Spacer(),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 10,
                    color: Colors.black54,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressCircle(Color primaryColor) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 50,
          width: 50,
          child: CircularProgressIndicator(
            value: progress,
            strokeWidth: 6,
            backgroundColor: primaryColor.withValues(alpha: 0.1),
            valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
          ),
        ),
        if (progressText.isNotEmpty)
          Text(
            progressText,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
      ],
    );
  }
}