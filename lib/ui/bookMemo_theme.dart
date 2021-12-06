import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Map<int, Color> colorOrange = {
  50: Color.fromRGBO(255, 198, 146, .1),
  100: Color.fromRGBO(255, 198, 146, .2),
  200: Color.fromRGBO(255, 198, 146, .3),
  300: Color.fromRGBO(255, 198, 146, .4),
  400: Color.fromRGBO(255, 198, 146, .5),
  500: Color.fromRGBO(255, 198, 146, .6),
  600: Color.fromRGBO(255, 198, 146, .7),
  700: Color.fromRGBO(255, 198, 146, .8),
  800: Color.fromRGBO(255, 198, 146, .9),
  900: Color.fromRGBO(255, 198, 146, 1),
};

const MaterialColor colorPrimary = MaterialColor(0xFFFFC692, colorOrange);
const Color colorPrimaryLight = Color(0xFFFFF3E8);
const Color colorSecondary = Color(0xFF5F61BF);

class BookMemoTheme {
  static TextTheme lightTextTheme = TextTheme(
    bodyText1: GoogleFonts.openSans(
      fontSize: 14.0,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    ),
    headline1: GoogleFonts.openSans(
      fontSize: 26.0,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    headline2: GoogleFonts.openSans(
      fontSize: 21.0,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    ),
    headline3: GoogleFonts.openSans(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
  );

  static ThemeData light() {
    return ThemeData(
      dividerColor: Colors.transparent,
      primarySwatch: colorPrimary,
      scaffoldBackgroundColor: Colors.white,
      brightness: Brightness.light,
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateColor.resolveWith((states) {
          return Colors.black;
        }),
      ),
      appBarTheme: const AppBarTheme(
        foregroundColor: Colors.black,
        backgroundColor: colorPrimaryLight,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        foregroundColor: Colors.white,
        backgroundColor: colorSecondary,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: colorSecondary,
      ),
      textTheme: lightTextTheme,
    );
  }

// todo add dark theme
}
