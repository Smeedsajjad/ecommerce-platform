import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class AppAppBarTheme{
  AppAppBarTheme._();

  static const appBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: true,
    backgroundColor: Colors.transparent,
    iconTheme: IconThemeData(color: AppColors.dark, size: 18.0),
    actionsIconTheme: IconThemeData(color: AppColors.dark, size: 18.0),
  );
}