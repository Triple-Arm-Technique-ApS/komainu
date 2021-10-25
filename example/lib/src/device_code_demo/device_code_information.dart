import 'package:flutter/material.dart';

class DeviceCodeInformation extends StatelessWidget {
  final VoidCallback onRefreshPressed;
  final VoidCallback onCopyCodePressed;
  final VoidCallback onOpenLinkPressed;
  final VoidCallback onCancelPressed;

  const DeviceCodeInformation({
    Key? key,
    required this.onRefreshPressed,
    required this.onCopyCodePressed,
    required this.onOpenLinkPressed,
    required this.onCancelPressed,
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
              'Authorization',
              style: Theme.of(context)
                  .textTheme
                  .headline5!
                  .copyWith(color: Theme.of(context).colorScheme.onPrimary),
            ),
            const SizedBox(
              height: 40,
            ),
            Text(
              'STEP 1',
              style: Theme.of(context).textTheme.subtitle1,
              textAlign: TextAlign.center,
            ),
            Text(
              'Copy the following code to your clipboard by clicking the icon or selecting the text.',
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: Theme.of(context).colorScheme.onPrimary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 30,
            ),
            _buildTextDisplay(
              context,
              Text(
                '1234',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 24,
                ),
                textAlign: TextAlign.center,
              ),
              IconButton(
                onPressed: onRefreshPressed,
                icon: const Icon(Icons.refresh),
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              IconButton(
                onPressed: onCopyCodePressed,
                icon: const Icon(Icons.copy),
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Text(
              'STEP 2',
              style: Theme.of(context).textTheme.subtitle1,
              textAlign: TextAlign.center,
            ),
            Text(
              'Navigate to the following link and enter the code you\'ve copied.\n' +
                  'Follow the provided instructions to authorize this application.',
              style: Theme.of(context).textTheme.bodyText1!,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 30,
            ),
            _buildTextDisplay(
              context,
              Text(
                'https://lol.dk/devicecode',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 40,
                width: 40,
              ),
              IconButton(
                onPressed: onOpenLinkPressed,
                icon: const Icon(Icons.open_in_new),
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Text(
              'STEP 3',
              style: Theme.of(context).textTheme.subtitle1,
              textAlign: TextAlign.center,
            ),
            Text(
              'Wait until the app updates or press cancel to abort.',
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: Theme.of(context).colorScheme.onPrimary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            TextButton(
              onPressed: onCancelPressed,
              child: const Text('CANCEL'),
            )
          ],
        ),
      ),
    );
  }

  Container _buildTextDisplay(
    BuildContext context,
    Text text,
    Widget leading,
    Widget trailing,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.3),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            leading,
            text,
            trailing,
          ],
        ),
      ),
    );
  }
}
