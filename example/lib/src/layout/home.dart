import 'package:example/src/device_code_demo/device_code_screen.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: DefaultTextStyle(
          style: Theme.of(context).textTheme.headline1!.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 32.0,
              ),
          child: const Text('KOMAINU'),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Sign in using:'),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _AuthTypeButton(
                  icon: Icons.security,
                  text: 'Auth code grant',
                  onPressed: () {},
                ),
                DefaultTextStyle(
                  style: Theme.of(context).textTheme.caption!,
                  child: const Text('OR'),
                ),
                _AuthTypeButton(
                  icon: Icons.devices_other_outlined,
                  text: 'Device code grant',
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DeviceCodeScreen(),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AuthTypeButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData icon;
  const _AuthTypeButton({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox.square(
          dimension: 92,
          child: ElevatedButton(
            child: Icon(icon),
            onPressed: onPressed,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(text)
      ],
    );
  }
}
