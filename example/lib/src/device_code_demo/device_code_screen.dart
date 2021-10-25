import 'package:example/src/device_code_demo/device_code_information.dart';
import 'package:flutter/material.dart';

import '../layout/dawer.dart';

class DeviceCodeScreen extends StatelessWidget {
  const DeviceCodeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const Expanded(child: Text('dsakdsa')),
          Theme(
            data: Theme.of(context).copyWith(
              textTheme: Theme.of(context).textTheme.copyWith(
                    headline5: Theme.of(context).textTheme.headline5!.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary),
                    subtitle1: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimary
                              .withOpacity(0.7),
                          fontWeight: FontWeight.w100,
                        ),
                    bodyText1: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                  ),
              inputDecorationTheme: const InputDecorationTheme(),
              textButtonTheme: TextButtonThemeData(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(
                    Theme.of(context).colorScheme.onPrimary,
                  ),
                  minimumSize: MaterialStateProperty.all(const Size(200, 60)),
                  textStyle: MaterialStateProperty.all(
                    Theme.of(context).textTheme.bodyText2!.copyWith(
                          fontWeight: FontWeight.w100,
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 16,
                        ),
                  ),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  overlayColor: MaterialStateProperty.all(
                    Colors.white.withOpacity(0.10),
                  ),
                  backgroundColor: MaterialStateProperty.resolveWith(
                    (states) {
                      if (states.contains(MaterialState.hovered)) {
                        return Colors.white.withOpacity(0.05);
                      }
                      if (states.contains(MaterialState.focused)) {
                        return Colors.white.withOpacity(0.10);
                      }
                      return Colors.white.withOpacity(0.10);
                    },
                  ),
                ),
              ),
            ),
            child: CustomDawer(
              child: DeviceCodeInformation(
                onRefreshPressed: () {},
                onCopyCodePressed: () {},
                onOpenLinkPressed: () {},
                onCancelPressed: () {},
              ),
              isVisible: true,
              direction: HorizontalDirection.end,
            ),
          ),
        ],
      ),
    );
  }
}
