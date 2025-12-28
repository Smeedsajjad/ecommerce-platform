import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/colors.dart';

/* -- Text Themes -- */
class AppTextTheme {
  AppTextTheme._(); //To avoid creating instances

  static TextTheme textTheme = TextTheme(
    displayLarge: GoogleFonts.poppins(fontSize: 28.0, fontWeight: FontWeight.bold, color:AppColors.dark),
    displayMedium: GoogleFonts.poppins(fontSize: 24.0, fontWeight: FontWeight.w700, color:AppColors.dark),
    displaySmall: GoogleFonts.poppins(fontSize: 24.0, fontWeight: FontWeight.normal, color:AppColors.dark),
    headlineMedium: GoogleFonts.poppins(fontSize: 18.0, fontWeight: FontWeight.w600, color:AppColors.dark),
    headlineSmall: GoogleFonts.poppins(fontSize: 18.0, fontWeight: FontWeight.normal, color:AppColors.dark),
    titleLarge: GoogleFonts.poppins(fontSize: 14.0, fontWeight: FontWeight.w600, color:AppColors.dark),
    bodyLarge: GoogleFonts.poppins(fontSize: 14.0, color:AppColors.dark),
    bodyMedium: GoogleFonts.poppins(fontSize: 14.0, color:AppColors.dark.withValues(alpha: 0.8)),
  );

}
