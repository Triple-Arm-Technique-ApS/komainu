import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

import 'layout/home.dart';

class KomainuExample extends StatelessWidget {
  const KomainuExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.audiowideTextTheme(),
        primarySwatch: Colors.deepOrange,
        colorScheme: const ColorScheme.light(
          primary: Colors.deepOrange,
          secondary: Colors.deepOrangeAccent,
        ),
      ),
      home: const Home(),
    );
  }
}
