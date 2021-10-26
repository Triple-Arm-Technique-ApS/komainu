import 'package:flutter/material.dart';

class Failed extends StatelessWidget {
  final String message;
  const Failed({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error),
          Text(message),
        ],
      ),
    );
  }
}
