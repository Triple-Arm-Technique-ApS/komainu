import 'package:flutter/material.dart';
import 'package:komainu/komainu.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: WellKnownConfigurationBuilder(
        wellKnownConfigurationEndpoint: Uri.parse(
          'https://tattestb2c.b2clogin.com/tattestb2c.onmicrosoft.com/B2C_1A_SIGNUP_SIGNIN/v2.0/.well-known/openid-configuration',
        ),
        builder: (context, state) {
          if (state.failed) {
            return Scaffold(
              body: Center(
                child: Text(
                  state.exception.toString(),
                ),
              ),
            );
          }
          if (state.successful) {
            return OAuthSessionBuilder(
              create: () => OAuthConfiguration.fromDiscoveryDocument(
                clientId: '4d9feb2f-7960-4155-8281-622bb4561fa2',
                redirectUri: Uri.parse('http://localhost:4200/callback.html'),
                scope: ['User.Read'],
                discoveryDocument: state.discoveryDocument!,
              ),
              builder: (context, state) {
                if (state.authorized) {
                  return Scaffold(
                    body: Center(
                      child: ElevatedButton(
                        onPressed: () => OAuthSession.of(context).signOut(),
                        child: const Text('Sign Out'),
                      ),
                    ),
                  );
                }
                return Scaffold(
                  body: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text('Device Code'),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text('Auth Code'),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return Container();
        },
      ),
    );
  }
}
