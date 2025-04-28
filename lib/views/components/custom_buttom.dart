import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double borderRadius;
  final Color buttonColor;
  final Color textColor;
  final double? width;
  final double height;
  final double iconSize;
  final IconData? icon;
  final Alignment? textAlign;
  final TextStyle? textStyle;
  final MainAxisAlignment? mainAxisAlignment;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.borderRadius = 5,
    this.buttonColor = const Color.fromARGB(255, 74, 74, 74),
    this.height = 40,
    this.icon,
    this.iconSize = 25,
    this.mainAxisAlignment,
    this.textAlign,
    this.textColor = const Color.fromARGB(255, 255, 255, 255),
    this.textStyle,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Center(
      child: InkWell(
        onTap: onPressed,
        child: Container(
          height: height,
          alignment: Alignment.center,
          width: width ?? size.width,
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.all(
              Radius.circular(borderRadius),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null)
                Padding(
                  padding: const EdgeInsets.only(
                    right: 8.0,
                  ),
                  child: Icon(
                    icon,
                    size: iconSize,
                    color: textColor,
                  ),
                ),
              Flexible(
                child: Text(
                  text,
                  overflow: TextOverflow.ellipsis,
                  style: textStyle ??
                      TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: textColor,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
