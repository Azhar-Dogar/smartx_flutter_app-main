// ignore_for_file: prefer_const_constructors

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:smartx_flutter_app/util/constants.dart';

class AppTextField extends StatelessWidget {
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String hint;
  final TextInputType textInputType;
  final bool isError;
  final double radius;
  final TextInputAction textInputAction;
  final bool isObscure;
  final double height;
  final bool readOnly;
  final int maxLines;
  final int minLines;
  final Function()? onTap;
  final String iniTialValue;
  final bool enable;
  final Color color;
  final Color hintcolor;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final Function()? onSuffixClick;
  final bool hasBorder;

  const AppTextField(
      {required this.hint,
      required this.textInputType,
      required this.isError,
      this.controller,
      this.onChanged,
      this.radius = 5.0,
      this.hasBorder = true,
      this.height = 55,
      this.iniTialValue = '',
      this.isObscure = false,
      this.readOnly = false,
      this.minLines = 1,
      this.maxLines = 1,
      this.onTap,
      this.enable = true,
      this.suffixIcon,
      this.hintcolor = Constants.colorSecondary,
      this.color = Colors.transparent,
      this.onSuffixClick,
      this.prefixIcon,
      this.textInputAction = TextInputAction.next});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height,
        padding: const EdgeInsets.only(left: 15),
        margin: const EdgeInsets.only(bottom: 10, top: 10),
        decoration: BoxDecoration(
            border: Border.all(
                color: hasBorder ? Color(0xffF7E9E2) : Colors.transparent),
            borderRadius: BorderRadius.circular(radius),
            color: color),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            prefixIcon != null
                ? Padding(
                    padding: const EdgeInsets.only(top: 3, right: 10),
                    child: prefixIcon!)
                : const SizedBox(),
            Expanded(
                child: TextFormField(
                    obscureText: isObscure,
                    controller: controller,
                    readOnly: readOnly,
                    onTap: onTap,
                    initialValue: controller == null ? iniTialValue : null,
                    minLines: minLines,
                    maxLines: maxLines,
                    enabled: enable,
                    onChanged: onChanged,
                    cursorColor: Constants.colorSecondary,
                    keyboardType: textInputType,
                    textInputAction: textInputAction,
                    style: TextStyle(
                        color: hintcolor,
                        // fontFamily: BaseConstants.hvRegular,
                        fontSize: 14),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.only(
                            top: maxLines > 1
                                ? 10
                                : prefixIcon != null
                                    ? 7
                                    : 10,
                            bottom: maxLines > 1 ? 0 : 10),
                        hintText: hint,
                        hintStyle: TextStyle(
                            color: Constants.colorSecondary,
                            fontWeight: FontWeight.w300,
                            // fontFamily: BaseConstants.hvRegular,
                            fontSize: 13)))),
            suffixIcon != null
                ? GestureDetector(
                    onTap: () => onSuffixClick?.call(),
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 3, horizontal: 5),
                        child: suffixIcon!))
                : const SizedBox()
          ],
        ));
  }
}

class DottedBorderAppTextField extends StatelessWidget {
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String hint;
  final TextInputType textInputType;
  final bool isError;
  final double radius;
  final TextInputAction textInputAction;
  final bool isObscure;
  final double height;
  final bool readOnly;
  final int maxLines;
  final int minLines;
  final Function()? onTap;
  final String iniTialValue;
  final bool enable;
  final Color color;
  final Color hintcolor;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final Function()? onSuffixClick;
  final bool hasBorder;

  const DottedBorderAppTextField(
      {required this.hint,
      required this.textInputType,
      required this.isError,
      this.controller,
      this.onChanged,
      this.radius = 5.0,
      this.hasBorder = true,
      this.height = 55,
      this.iniTialValue = '',
      this.isObscure = false,
      this.readOnly = false,
      this.minLines = 1,
      this.maxLines = 1,
      this.onTap,
      this.enable = true,
      this.suffixIcon,
      this.hintcolor = Constants.colorSecondary,
      this.color = Colors.transparent,
      this.onSuffixClick,
      this.prefixIcon,
      this.textInputAction = TextInputAction.next});

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      radius: Radius.circular(10),
      color: Constants.colorTextField,
      child: Container(
          height: height,
          padding: const EdgeInsets.only(left: 15),
          margin: const EdgeInsets.only(bottom: 10, top: 10),
          decoration: BoxDecoration(
            
              borderRadius: BorderRadius.circular(radius),
              color: color),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              prefixIcon != null
                  ? Padding(
                      padding: const EdgeInsets.only(top: 3, right: 10),
                      child: prefixIcon!)
                  : const SizedBox(),
              Expanded(
                  child: TextFormField(
                      obscureText: isObscure,
                      controller: controller,
                      readOnly: readOnly,
                      onTap: onTap,
                      initialValue: controller == null ? iniTialValue : null,
                      minLines: minLines,
                      maxLines: maxLines,
                      enabled: enable,
                      onChanged: onChanged,
                      cursorColor: Constants.colorSecondary,
                      keyboardType: textInputType,
                      textInputAction: textInputAction,
                      style: TextStyle(
                          color: hintcolor,
                          // fontFamily: BaseConstants.hvRegular,
                          fontSize: 14),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                              top: maxLines > 1
                                  ? 10
                                  : prefixIcon != null
                                      ? 7
                                      : 10,
                              bottom: maxLines > 1 ? 0 : 10),
                          hintText: hint,
                          hintStyle: TextStyle(
                              color: Constants.colorSecondary,
                              fontWeight: FontWeight.w300,
                              // fontFamily: BaseConstants.hvRegular,
                              fontSize: 13)))),
              suffixIcon != null
                  ? GestureDetector(
                      onTap: () => onSuffixClick?.call(),
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 3, horizontal: 5),
                          child: suffixIcon!))
                  : const SizedBox()
            ],
          )),
    );
  }
}
