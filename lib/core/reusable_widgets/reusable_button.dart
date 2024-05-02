import 'package:flutter/material.dart';

class ReusableButton extends StatelessWidget {
  final String text;
  final Color buttonColor;
  final Color textColor;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry? padding;
  final double circularRadius;
  final double? fontSize;
  const ReusableButton({
    super.key,
    required this.buttonColor,
    required this.text,
    required this.textColor,
    this.onPressed,
    this.padding,
    this.circularRadius = 18,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.shortestSide <= 600;

    return Container(
      padding: padding ?? EdgeInsets.symmetric(horizontal: 45),
      height: 55,
      width: double.maxFinite,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.all(Radius.circular(circularRadius))),
            backgroundColor: buttonColor),
        child: Text(
          text,
          style: TextStyle(fontSize: 22, color: textColor),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
