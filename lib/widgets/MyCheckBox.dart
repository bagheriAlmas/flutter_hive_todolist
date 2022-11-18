import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../main.dart';

class MyCheckBox extends StatelessWidget {
  final bool value;
  final GestureTapCallback onTap;

  const MyCheckBox({Key? key, required this.value, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border:
          !value ? Border.all(width: 2, color: secondaryTextColor) : null,
          color: value ? primaryColor : null,
        ),
        child: value
            ? Icon(
          CupertinoIcons.checkmark_alt,
          color: themeData.colorScheme.onPrimary,
          size: 18,
        )
            : null,
      ),
    );
  }
}
