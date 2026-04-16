import 'package:flutter/material.dart';
import 'package:qassa/core/theme/theme_context_extension.dart';
import 'package:go_router/go_router.dart';

// ════════════════════════════════════
// FACTORY SHELL
// ════════════════════════════════════
class FactoryShellPage extends StatelessWidget {
  final StatefulNavigationShell shell;
  const FactoryShellPage({super.key, required this.shell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: shell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: context.colors.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 60,
            child: Row(
              children: [
                _FactoryNavItem(
                  index: 0,
                  emoji: '📊',
                  label: 'الرئيسية',
                  current: shell.currentIndex,
                  onTap: () => _go(0),
                ),
                _FactoryNavItem(
                  index: 1,
                  emoji: '📋',
                  label: 'الطلبات',
                  current: shell.currentIndex,
                  onTap: () => _go(1),
                ),
                _FactoryNavItem(
                  index: 2,
                  emoji: '📤',
                  label: 'عروضي',
                  current: shell.currentIndex,
                  onTap: () => _go(2),
                ),
                _FactoryNavItem(
                  index: 3,
                  emoji: '👤',
                  label: 'حسابي',
                  current: shell.currentIndex,
                  onTap: () => _go(3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _go(int i) =>
      shell.goBranch(i, initialLocation: i == shell.currentIndex);
}

class _FactoryNavItem extends StatelessWidget {
  final int index;
  final String emoji;
  final String label;
  final int current;
  final VoidCallback onTap;

  const _FactoryNavItem({
    required this.index,
    required this.emoji,
    required this.label,
    required this.current,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = index == current;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 10,
                color: isActive ? context.colors.primary : context.colors.textDisabled,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
            const SizedBox(height: 2),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: isActive ? 18 : 0,
              height: 3,
              decoration: BoxDecoration(
                color: context.colors.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
