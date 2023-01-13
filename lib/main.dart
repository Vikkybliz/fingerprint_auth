import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

void main() {
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  LocalAuthentication authentication = LocalAuthentication();
  Future authenticate() async {
    final bool isBiometircAvailable = await authentication.isDeviceSupported();
    if (!isBiometircAvailable) return false;
    try {
      return await authentication.authenticate(
          localizedReason: "Authenticate to view your secret",
          options: const AuthenticationOptions(
            biometricOnly: true,
            useErrorDialogs: true,
            stickyAuth: true,
          ));
    } on PlatformException catch (e) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Authenticate with Fingerprint"),
      ),
      body: Center(
        child: ElevatedButton(
            onPressed: () async {
              bool isAuthenticated = await authenticate();
              if (isAuthenticated) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => const SecretPage())));
              } else {
                SizedBox();
              }
            },
            child: const Text('Go to secret page')),
      ),
    );
  }
}

class SecretPage extends StatelessWidget {
  const SecretPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Secret Page"),
      ),
      body: const Center(child: Text("Hooray, Your secret is still safe")),
    );
  }
}
