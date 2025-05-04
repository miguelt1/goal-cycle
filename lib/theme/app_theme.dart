import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontFamily: 'Roboto', fontSize: 16, fontWeight: FontWeight.w500),
          bodyMedium: TextStyle(fontFamily: 'Roboto', fontSize: 14, color: Colors.grey),
          headlineLarge: TextStyle(fontFamily: 'Roboto', fontSize: 18, fontWeight: FontWeight.bold),
        ),
);