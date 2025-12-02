import 'package:flutter/material.dart';

/* -- CheckBox Themes -- */
class AppCheckboxTheme {
  AppCheckboxTheme._();

  static final checkBoxTheme = CheckboxThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadiusGeometry.circular(4),
      side: BorderSide(color: Colors.grey.shade200),
    ),
  );
}
