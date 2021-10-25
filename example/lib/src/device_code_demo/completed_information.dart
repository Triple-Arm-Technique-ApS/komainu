import 'package:flutter/material.dart';

class CompletedInformation extends StatelessWidget {
  final VoidCallback onGoPressed;
  const CompletedInformation({
    Key? key,
    required this.onGoPressed,
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
              'Great Success!!',
              style: Theme.of(context).textTheme.headline5,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Out have now succesfully signed in using device code',
              style: Theme.of(context).textTheme.bodyText1,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 40,
            ),
            TextButton(
              onPressed: onGoPressed,
              child: const Text(
                'GO',
              ),
            )
          ],
        ),
      ),
    );
  }
}
