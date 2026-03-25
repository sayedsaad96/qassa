import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/app_responsive.dart';
import '../../../../core/widgets/app_widgets.dart';

class PrivacySecurityPage extends StatelessWidget {
  const PrivacySecurityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
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
                  const Icon(
                    Icons.security_rounded,
                    size: 64,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 16),
                  Text('الخصوصية والأمان', style: AppTextStyles.h3),
                  const SizedBox(height: 8),
                  Text(
                    'سيتم توفير هذه الميزة قريباً..',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textSecondary,
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
