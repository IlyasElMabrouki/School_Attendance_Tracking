import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/costume_colors.dart';

class ShenTheme {
  static TextTheme lightTextTheme = TextTheme(
      bodyText1: GoogleFonts.poppins(
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
          color: CostumeColors.grey1),
      bodyText2: GoogleFonts.poppins(
          fontSize: 14.0,
          fontWeight: FontWeight.w300,
          color: CostumeColors.grey3),
      headline1: GoogleFonts.poppins(
          fontSize: 32.0,
          fontWeight: FontWeight.bold,
          color: CostumeColors.grey1),
      headline2: GoogleFonts.poppins(
          fontSize: 21.0,
          fontWeight: FontWeight.w700,
          color: CostumeColors.grey1),
      headline3: GoogleFonts.poppins(
          fontSize: 18.0,
          fontWeight: FontWeight.w600,
          color: CostumeColors.grey1),
      headline6: GoogleFonts.poppins(
          fontSize: 14.0,
          fontWeight: FontWeight.w600,
          color: CostumeColors.grey1)
  );

  static ThemeData light() {
    return ThemeData(
        brightness: Brightness.light,
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateColor.resolveWith(
            (states) {
              return Colors.black;
            },
          ),
        ),
        appBarTheme: AppBarTheme(
          foregroundColor: Colors.white,
          backgroundColor: CostumeColors.blue,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          foregroundColor: CostumeColors.blue,
          backgroundColor: Colors.white,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: CostumeColors.blue80,
        ),
        textTheme: lightTextTheme,
        inputDecorationTheme: InputDecorationTheme(
            border: const OutlineInputBorder(),
            focusColor: CostumeColors.blue)
     );
  }
}
