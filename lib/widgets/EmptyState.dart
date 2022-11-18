import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
class EmptyState extends StatelessWidget {
  const EmptyState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          "assets/empty.svg",
          width: 256,
        ),
        const SizedBox(height: 40),
        const Text("Your Task List is Empty"),
        const SizedBox(height: 200),
      ],
    );
  }
}
