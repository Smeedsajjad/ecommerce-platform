import 'package:flutter/material.dart';
import 'package:ecommerence/utils/constants/sizes.dart';

class AppSpacingStyle {
  static const EdgeInsetsGeometry paddingWithAppBarHeight =
      EdgeInsetsGeometry.only(
        top: AppSizes.appBarHeight,
        bottom: AppSizes.defaultSpace,
        left: AppSizes.defaultSpace,
        right: AppSizes.defaultSpace
      );
}
