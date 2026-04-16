import 'package:flutter/material.dart';
import 'package:qassa/core/theme/theme_context_extension.dart';
import '../../../../core/utils/app_responsive.dart';
import '../../../../core/widgets/app_widgets.dart';

class PrivacySecurityPage extends StatelessWidget {
  const PrivacySecurityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(title: const Text('الخصوصية والأمان')),
      body: ResponsiveCenter(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: AppCard(
            padding: const EdgeInsets.all(32.0),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.security_rounded,
                    size: 64,
                    color: context.colors.primary,
                  ),
                  const SizedBox(height: 16),
                  Text('الخصوصية والأمان', style: context.textStyles.h3),
                  const SizedBox(height: 8),
                  Text(
                    'سيتم توفير هذه الميزة قريباً..',
                    style: context.textStyles.body.copyWith(
                      color: context.colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
