import 'package:flutter/material.dart';

class WelcomeInformation extends StatelessWidget {
  final VoidCallback onLetsGetStartedPressed;
  const WelcomeInformation({
    Key? key,
    required this.onLetsGetStartedPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Device Code',
              style: Theme.of(context).textTheme.headline5,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Example of device code grant usage in Flutter.',
              style: Theme.of(context).textTheme.bodyText1,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'To get started you need to authorize this application.',
              style: Theme.of(context).textTheme.bodyText1,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 40,
            ),
            TextButton(
              onPressed: onLetsGetStartedPressed,
              child: const Text(
                'LET\'S START!',
              ),
            )
          ],
        ),
      ),
    );
  }
}
