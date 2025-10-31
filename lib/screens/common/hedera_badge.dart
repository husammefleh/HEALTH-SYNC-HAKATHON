import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

class HederaBadge extends StatelessWidget {
  const HederaBadge({
    super.key,
    this.compact = false,
  });

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final label = compact
        ? context.l10n.translate('hederaBadgeShort')
        : context.l10n.translate('hederaBadge');

    final textStyle = theme.textTheme.labelSmall?.copyWith(
      color: compact ? colorScheme.primary : colorScheme.onPrimary,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.2,
    );

    if (compact) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: colorScheme.primary.withAlpha(32),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_done, size: 14, color: colorScheme.primary),
            const SizedBox(width: 4),
            Text(label, style: textStyle),
          ],
        ),
      );
    }

    return Chip(
      visualDensity: VisualDensity.compact,
      avatar: Icon(Icons.cloud_done, size: 16, color: colorScheme.onPrimary),
      label: Text(label, style: textStyle),
      backgroundColor: colorScheme.primary,
    );
  }
}
