import 'package:flutter/material.dart';

class MiTema {
  tema() {
    return ThemeData(
      // Define the default brightness and colors.
      brightness: Brightness.light,
      bottomAppBarColor: Colors.green[900],
      primarySwatch: Colors.green,
      buttonColor: Colors.greenAccent,
      backgroundColor: Colors.green[100],
      primaryColorLight: Colors.white,
      accentColor: Colors.green[600],
      buttonTheme: ButtonThemeData(
          textTheme: ButtonTextTheme.normal,
          buttonColor: Colors.green[600],
          colorScheme: ColorScheme.light()),

      // Define the default TextTheme. Use this to specify the default
      // text styling for headlines, titles, bodies of text, and more.
      textTheme: TextTheme(
        bodyText2: TextStyle(fontSize: 16.0),
      ),
      
    );
  }
  light(){
    return ThemeData(
      accentColor: Colors.green[600],
      brightness: Brightness.light,
      backgroundColor: Colors.green[100],
      primaryColor: Colors.green
     
    );
  }
}
