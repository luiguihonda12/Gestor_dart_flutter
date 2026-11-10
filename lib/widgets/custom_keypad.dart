import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class CustomKeypad extends StatelessWidget {
  final Function(String key) onKeyPress;
  final VoidCallback onBackspace;

  const CustomKeypad({
    super.key,
    required this.onKeyPress,
    required this.onBackspace,
  });

  Widget _buildKey(
    BuildContext context,
    String label, {
    Widget? customWidget,
    VoidCallback? onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppTheme.primaryObsidian : AppTheme.surfaceCard;
    final borderColor =
        isDark ? const Color(0xFF2A2B2E) : AppTheme.outlineHairline;
    final textColor = isDark ? Colors.white : AppTheme.primaryObsidian;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap ?? () => onKeyPress(label),
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            border: Border.all(color: borderColor, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: customWidget ??
              Text(
                label,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: textColor,
                  fontFamily: 'serif',
                ),
              ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildKey(context, '1')),
              const SizedBox(width: 8),
              Expanded(child: _buildKey(context, '2')),
              const SizedBox(width: 8),
              Expanded(child: _buildKey(context, '3')),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _buildKey(context, '4')),
              const SizedBox(width: 8),
              Expanded(child: _buildKey(context, '5')),
              const SizedBox(width: 8),
              Expanded(child: _buildKey(context, '6')),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _buildKey(context, '7')),
              const SizedBox(width: 8),
              Expanded(child: _buildKey(context, '8')),
              const SizedBox(width: 8),
              Expanded(child: _buildKey(context, '9')),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _buildKey(context, '.')),
              const SizedBox(width: 8),
              Expanded(child: _buildKey(context, '0')),
              const SizedBox(width: 8),
              Expanded(
                child: _buildKey(
                  context,
                  'backspace',
                  onTap: onBackspace,
                  customWidget: const Icon(
                    Icons.backspace_outlined,
                    size: 20,
                    color: AppTheme.secondarySlate,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
