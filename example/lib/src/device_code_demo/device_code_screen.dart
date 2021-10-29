import 'package:example/src/device_code_demo/welcome_information.dart';
import 'package:example/src/layout/dawer.dart';
import 'package:example/src/loading/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:komainu/komainu.dart';

import 'welcome_information.dart';

class DeviceCodeScreen extends StatelessWidget {
  const DeviceCodeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   title:
      // DefaultTextStyle(
      //     style: Theme.of(context).textTheme.headline1!.copyWith(
      //           color: Theme.of(context).colorScheme.primary,
      //           fontSize: 32.0,
      //         ),
      //     child: const Text('KOMAINU'),
      //   ),
      // ),
      body: WellKnownConfigurationConsumer(
        wellKnownConfigurationEndpoint: Uri.parse(
          'https://login.microsoftonline.com/common/v2.0/.well-known/openid-configuration',
        ),
        listener: (context, state) {
          if (state.status == WellKnownConfigurationStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.failureDetails!.message),
              duration: const Duration(seconds: 1),
              action: SnackBarAction(
                label: 'Dismiss',
                onPressed: () {},
              ),
            ));
          }
          if (state.status == WellKnownConfigurationStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Successfully got the discovery document'),
                duration: const Duration(seconds: 1),
                action: SnackBarAction(
                  label: 'Dismiss',
                  onPressed: () {},
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status == WellKnownConfigurationStatus.success) {
            return OAuthSessionConsumer(
              create: () => OAuthConfiguration.fromDiscoveryDocument(
                clientId: '4de9953a-e516-44e2-8faf-54556c3f46a8',
                redirectUri: Uri.parse(
                  'https://localhost:4200/callback.html',
                ),
                scope: ['User.Read'],
                discoveryDocument: state.discoveryDocument!,
              ),
              builder: (context, state) {
                return Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: DefaultTextStyle(
                          style: Theme.of(context)
                              .textTheme
                              .headline1!
                              .copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 32.0,
                              ),
                          child: const Text('KOMAINU'),
                        ),
                      ),
                    ),
                    CustomDawer(
                      child: WelcomeInformation(
                        onLetsGetStartedPressed: () {},
                      ),
                      isVisible: true,
                      direction: HorizontalDirection.end,
                    )
                  ],
                );
              },
              listener: (context, state) {},
            );
          }
          return const LoadingLogo();
        },
      ),
    );

    // return WellKnownConfigurationConsumer(
    //   wellKnownConfigurationEndpoint: Uri.parse(
    //     'https://login.microsoftonline.com/common/v2.0/.well-known/openid-configuration',
    //   ),
    //   listener: (context, state) {
    //     if (state.failed) {
    //       print('FAAAILLLED');
    //     }
    //   },
    //   builder: (context, state) {
    //     if (state.successful) {
    //       return OAuthSessionBuilder(
    //         create: () => OAuthConfiguration.fromDiscoveryDocument(
    //           clientId: '4de9953a-e516-44e2-8faf-54556c3f46a8',
    //           redirectUri: Uri.parse(
    //             'https://localhost:4200/callback.html',
    //           ),
    //           scope: ['User.Read'],
    //           discoveryDocument: state.discoveryDocument!,
    //         ),
    //         builder: (context, state) {
    //           if (state.authorized) {
    //             return const ProfileScreen();
    //           }
    //           if (state.initial) {
    //             return Scaffold(
    //               body: Row(
    //                 children: [
    //                   const Expanded(child: Text('dsakdsa')),
    //                   Theme(
    //                     data: Theme.of(context).copyWith(
    //                       textTheme: Theme.of(context).textTheme.copyWith(
    //                             headline5: Theme.of(context)
    //                                 .textTheme
    //                                 .headline5!
    //                                 .copyWith(
    //                                     color: Theme.of(context)
    //                                         .colorScheme
    //                                         .onPrimary),
    //                             subtitle1: Theme.of(context)
    //                                 .textTheme
    //                                 .subtitle1!
    //                                 .copyWith(
    //                                   color: Theme.of(context)
    //                                       .colorScheme
    //                                       .onPrimary
    //                                       .withOpacity(0.7),
    //                                   fontWeight: FontWeight.w100,
    //                                 ),
    //                             bodyText1: Theme.of(context)
    //                                 .textTheme
    //                                 .bodyText1!
    //                                 .copyWith(
    //                                   color: Theme.of(context)
    //                                       .colorScheme
    //                                       .onPrimary,
    //                                 ),
    //                           ),
    //                       inputDecorationTheme: const InputDecorationTheme(),
    //                       textButtonTheme: TextButtonThemeData(
    //                         style: ButtonStyle(
    //                           foregroundColor: MaterialStateProperty.all(
    //                             Theme.of(context).colorScheme.onPrimary,
    //                           ),
    //                           minimumSize: MaterialStateProperty.all(
    //                               const Size(200, 60)),
    //                           textStyle: MaterialStateProperty.all(
    //                             Theme.of(context).textTheme.bodyText2!.copyWith(
    //                                   fontWeight: FontWeight.w100,
    //                                   color: Theme.of(context)
    //                                       .colorScheme
    //                                       .onPrimary,
    //                                   fontSize: 16,
    //                                 ),
    //                           ),
    //                           shape: MaterialStateProperty.all(
    //                             RoundedRectangleBorder(
    //                               borderRadius: BorderRadius.circular(8.0),
    //                             ),
    //                           ),
    //                           overlayColor: MaterialStateProperty.all(
    //                             Colors.white.withOpacity(0.10),
    //                           ),
    //                           backgroundColor:
    //                               MaterialStateProperty.resolveWith(
    //                             (states) {
    //                               if (states.contains(MaterialState.hovered)) {
    //                                 return Colors.white.withOpacity(0.05);
    //                               }
    //                               if (states.contains(MaterialState.focused)) {
    //                                 return Colors.white.withOpacity(0.10);
    //                               }
    //                               return Colors.white.withOpacity(0.10);
    //                             },
    //                           ),
    //                         ),
    //                       ),
    //                     ),
    //                     child: CustomDawer(
    //                       child: DeviceCodeInformation(
    //                         onRefreshPressed: () {},
    //                         onCopyCodePressed: () {},
    //                         onOpenLinkPressed: () {},
    //                         onCancelPressed: () {},
    //                       ),
    //                       isVisible: true,
    //                       direction: HorizontalDirection.end,
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             );
    //           }
    //           if (state.expired) {
    //             return const WelcomeScreen();
    //           }
    //           return const LoadingScreen();
    //         },
    //       );
    //     }
    //     return const LoadingScreen();
    //   },
    // );
  }
}
