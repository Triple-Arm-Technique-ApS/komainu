import '../layout/dawer.dart';
import 'package:flutter/material.dart';

class DeviceCodeScreen extends StatelessWidget {
  const DeviceCodeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Device Code'),
      // ),
      body: Row(
        children: [
          const Expanded(child: Text('dsakdsa')),
          CustomDawer(
            child: Column(),
            isVisible: true,
            direction: HorizontalDirection.end,
          ),
        ],
      ),
    );
  }
}
