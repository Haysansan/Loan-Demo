import 'package:flutter/material.dart';
import 'package:apploan/core/core.dart';

/// [isSelected]  → green filled background (active state)
/// [isAlert]     → red border/text (used for Disbursement tab)
class ApproveTabButton extends StatelessWidget {
  const ApproveTabButton({
    Key? key,
    required this.count,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.isAlert = false,
  }) : super(key: key);

  final int count;
  final String label;
  final bool isSelected;
  final bool isAlert;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color bgColor = isSelected ? AppColor.primary : Colors.white;
    final Color textColor =
        isSelected
            ? Colors.white
            : (isAlert ? const Color(0xFF008B0C) : Colors.black87);
    final Color borderColor =
        isSelected
            ? AppColor.primary
            : (isAlert ? const Color(0xFF008B0C) : AppColor.lightGrey);

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: UIConstants.radius.radiusAll,
            border: Border.all(color: borderColor, width: 1.5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                count.toString(),
                style: TextStyle(
                  color: textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(color: textColor, fontSize: 11),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
