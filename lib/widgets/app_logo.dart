import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double height;
  final double? width;

  const AppLogo({
    super.key,
    this.height = 48,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return ColorFiltered(
      colorFilter: ColorFilter.mode(primary, BlendMode.srcIn),
      child: Image.asset(
        'assets/logo.png',
        height: height,
        width: width,
        fit: BoxFit.contain,
      ),
    );
  }
}
