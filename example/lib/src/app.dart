import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class KomainuExample extends StatelessWidget {
  const KomainuExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: Colors.deepOrange,
          secondary: Colors.deepOrangeAccent,
        ),
      ),
      builder: (context, widget) => const Scaffold(
        body: Center(
          child: Text('Hola'),
        ),
      ),
    );
  }
}
