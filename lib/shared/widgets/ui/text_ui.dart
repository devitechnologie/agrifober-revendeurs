import 'package:flutter/material.dart';
// local imports
import 'package:agrifober_resellers/config/config.dart';
import 'package:agrifober_resellers/gen/fonts.gen.dart';

enum CustomTextAlign { left, center, right }

enum CustomFontStyle { normal, italic }

enum CustomTextDecoration {
  none,
  underline,
  overline,
  lineThrough;

  static TextDecoration fromEnum(CustomTextDecoration? decoration) {
    switch (decoration) {
      case CustomTextDecoration.underline:
        return TextDecoration.underline;
      case CustomTextDecoration.overline:
        return TextDecoration.overline;
      case CustomTextDecoration.lineThrough:
        return TextDecoration.lineThrough;
      case CustomTextDecoration.none:
      default:
        return TextDecoration.none;
    }
  }
}

class CustomTextStyle extends TextStyle {
  const CustomTextStyle._({
    super.fontSize,
    super.color,
    super.fontFamily,
    super.fontStyle,
    super.fontWeight,
    super.letterSpacing,
    super.height,
    super.decoration,
    super.decorationColor,
  });

  factory CustomTextStyle({
    double? fontSize,
    Color? color,
    FontWeight fontWeight = AppFontWeight.regular,
    CustomFontStyle? fontStyle,
    double? letterSpacing,
    double? height,
    CustomTextDecoration? decoration,
  }) {
    return CustomTextStyle._(
      fontSize: fontSize,
      color: color,
      fontFamily: FontFamily.roobertPRO,
      fontStyle: fontStyle == CustomFontStyle.italic
          ? FontStyle.italic
          : FontStyle.normal,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      height: height,
      decoration: CustomTextDecoration.fromEnum(decoration),
      decorationColor: color,
    );
  }
}

class TextUI extends StatelessWidget {
  const TextUI(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
  });

  final String text;
  final CustomTextStyle? style;
  final CustomTextAlign? textAlign;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    final defaultStyle = const TextStyle(
      fontSize: AppFontSize.base,
      color: AppColors.black,
    );

    return Text(
      text,
      style: defaultStyle.merge(style),
      textAlign: _mapTextAlign(textAlign),
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : null,
    );
  }

  // richText
  static Widget rich(
    String text, {
    TextStyle? style,
    List<TextSpan>? children,
    CustomTextAlign? textAlign,
  }) {
    return RichText(
      text: TextSpan(text: text, style: style, children: children),
      textAlign: _mapTextAlign(textAlign),
    );
  }

  static TextAlign _mapTextAlign(CustomTextAlign? align) {
    switch (align) {
      case CustomTextAlign.left:
        return TextAlign.left;
      case CustomTextAlign.center:
        return TextAlign.center;
      case CustomTextAlign.right:
        return TextAlign.right;
      default:
        return TextAlign.left;
    }
  }
}
