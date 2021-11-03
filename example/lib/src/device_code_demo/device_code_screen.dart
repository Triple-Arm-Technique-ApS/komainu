import 'package:url_launcher/url_launcher.dart';
import 'package:clipboard/clipboard.dart';
import 'package:example/src/device_code_demo/device_code_information.dart';
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
      body: WellKnownConfigurationConsumer(
        wellKnownConfigurationEndpoint: Uri.parse(
          'https://login.microsoftonline.com/common/v2.0/.well-known/openid-configuration',
        ),
        listener: (context, state) {
          if (state.status == WellKnownConfigurationStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.failureDetails!.message),
                duration: const Duration(seconds: 1),
                action: SnackBarAction(
                  label: 'Dismiss',
                  onPressed: () {},
                ),
              ),
            );
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
            final configuration = OAuthConfiguration.fromDiscoveryDocument(
              clientId: '4de9953a-e516-44e2-8faf-54556c3f46a8',
              redirectUri: Uri.parse(
                'https://localhost:4200/callback.html',
              ),
              scope: ['User.Read', 'offline_access'],
              discoveryDocument: state.discoveryDocument!,
            );
            return OAuthSessionConsumer(
              create: () => configuration,
              builder: (context, state) {
                if (state.status == OAuthSessionStateStatus.authorized) {
                  return Text('rofsaodoasd');
                }
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
                      child: DeviceCodeConsumer(
                        create: () => configuration,
                        listener: (context, state) {
                          if (state.status == DeviceCodeStatus.success) {
                            OAuthSession.of(context).signIn(state.credentials!);
                          }
                          if (state.status == DeviceCodeStatus.cancelled) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Authorization Cancelled!'),
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
                          return AnimatedSwitcher(
                            duration: const Duration(
                              milliseconds: 500,
                            ),
                            child: _buildFromState(
                              context,
                              state,
                            ),
                          );
                        },
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
  }

  Widget _buildFromState(BuildContext context, DeviceCodeState state) {
    switch (state.status) {
      case DeviceCodeStatus.cancelled:
        return WelcomeInformation(
          onLetsGetStartedPressed: () {
            DeviceCode.of(context).start();
          },
        );
      case DeviceCodeStatus.initial:
        return WelcomeInformation(
          onLetsGetStartedPressed: () {
            DeviceCode.of(context).start();
          },
        );
      case DeviceCodeStatus.running:
        return DeviceCodeInformation(
          userCode: state.userCode!,
          verificationUri: state.verificationUri!,
          onRefreshPressed: () {
            DeviceCode.of(context).restart();
          },
          onCopyCodePressed: () {
            FlutterClipboard.copy(state.userCode!).then((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'User code added to clipboard: ${state.userCode!}',
                  ),
                  duration: const Duration(seconds: 1),
                  action: SnackBarAction(
                    label: 'Dismiss',
                    onPressed: () {},
                  ),
                ),
              );
            });
          },
          onOpenLinkPressed: () async {
            await canLaunch(state.verificationUri!.toString())
                ? await launch(state.verificationUri!.toString())
                : ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Unable to launch ${state.verificationUri!}',
                      ),
                      duration: const Duration(seconds: 1),
                      action: SnackBarAction(
                        label: 'Dismiss',
                        onPressed: () {},
                      ),
                    ),
                  );
          },
          onCancelPressed: () {
            DeviceCode.of(context).cancel();
          },
        );
      default:
        return const SizedBox();
    }
  }
}
