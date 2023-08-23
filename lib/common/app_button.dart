import 'package:flutter/material.dart';
import 'package:smartx_flutter_app/util/constants.dart';


class AppButton extends StatelessWidget {
  final String text;
  final Function? onClick;
  final double borderRadius;
  final Color? color;
  final Color? textColor;
  final bool isBorder;

  final double fontSize;
  final bool isEnabled;
  final String fontFamily;

  const AppButton(
      {required this.text,
      required this.onClick,
      this.borderRadius = 6,
      this.color,
      this.fontFamily = Constants.workSansBold,
      this.textColor,
      this.fontSize = 15,
      this.isBorder = true,
      this.isEnabled = true});

  @override
  Widget build(BuildContext context) {

    return Container(
        margin: const EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          color: color,
            borderRadius: BorderRadius.circular(borderRadius)),
        child: RawMaterialButton(

            constraints: const BoxConstraints(minHeight: 44, maxHeight: 44),
            onPressed: isEnabled ? () => onClick?.call() : null,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius)),
            child: Text(text,
                style: TextStyle(
                    color: textColor ?? Colors.white,
                    fontFamily: fontFamily,
                    fontSize: fontSize))));
  }
}

class IconAppButton extends StatelessWidget {
  final Widget? prefixIcon;
  final bool isBorder;
  final String text;
  final Function? onClick;
  final double borderRadius;
  final Color? color;
  final Color? textColor;
  final double fontSize;
  final bool isEnabled;
  final String fontFamily;

  const IconAppButton(
      {required this.text,
      required this.onClick,
      this.borderRadius = 8,
      this.isBorder = false,
      this.color,
      this.fontFamily = Constants.workSansBold,
      this.textColor,
      this.fontSize = 15,
      this.isEnabled = true,
      this.prefixIcon});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
          border: Border.all(
              color: isBorder
                  ? textColor ?? Colors.transparent
                  : Colors.transparent),
          borderRadius: BorderRadius.circular(borderRadius)),
      child: RawMaterialButton(
          constraints: const BoxConstraints(minHeight: 44, maxHeight: 44),
          onPressed: isEnabled ? () => onClick?.call() : null,
          fillColor: isEnabled ? color : Colors.white54,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius)),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                prefixIcon != null ? prefixIcon! : const SizedBox(),
                SizedBox(width: prefixIcon != null ? 5 : 0),
                Text(text,
                    style: TextStyle(
                        color: textColor,
                        fontFamily: fontFamily,
                        fontSize: fontSize))
              ])),
    );
  }
}
