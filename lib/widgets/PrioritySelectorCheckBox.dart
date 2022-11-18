import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../main.dart';


class PeriorityCheckBox extends StatelessWidget {
  final String label;
  final Color color;
  final bool isSelected;
  final GestureTapCallback onTap;

  const PeriorityCheckBox(
      {Key? key,
        required this.label,
        required this.color,
        required this.isSelected,
        required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
                width: 2, color: secondaryTextColor.withOpacity(0.2))),
        child: Stack(
          children: [
            Center(child: Text(label)),
            Positioned(
              right: 8,
              top: 0,
              bottom: 0,
              child: Center(
                  child: PrioritySelectorCheckBox(
                    value: isSelected,
                    color: color,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

class PrioritySelectorCheckBox extends StatelessWidget {
  final bool value;
  final Color color;

  const PrioritySelectorCheckBox({Key? key, required this.value, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: color,
      ),
      child: value
          ? Icon(
        CupertinoIcons.checkmark_alt,
        color: themeData.colorScheme.onPrimary,
        size: 18,
      )
          : null,
    );
  }
}
