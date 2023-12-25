// ignore_for_file: unused_field

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final Logger _logger = Logger();

  String _errortext = '';
  bool _isSignedIn = false;
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: "Username",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: "Password",
                      errorText: _errortext.isNotEmpty ? _errortext : null,
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                    obscureText: _obscurePassword,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _performSignIn();
                    },
                    child: const Text('Sign In'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'Not Registered ?',
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Sign Up',
                            style: const TextStyle(
                              color: Colors.black,
                              decoration: TextDecoration.underline,
                              fontSize: 16,
                            ),
                            recognizer: TapGestureRecognizer()..onTap = () {}),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _performSignIn() async {
    try {
      final Future<SharedPreferences> prefsFuture =
          SharedPreferences.getInstance();

      final String username = _usernameController.text;
      final String password = _passwordController.text;
      _logger.d('Sign In Attempt');

      if (username.isNotEmpty && password.isNotEmpty) {
        final SharedPreferences prefs = await prefsFuture;
        final data = await _retrieveAndDecryptDataFromPrefs(
            prefs as Future<SharedPreferences>);
        if (data.isNotEmpty) {
          final decryptedUsername = data['username'];
          final decryptedPassword = data['password'];

          if (username == decryptedUsername && password == decryptedPassword) {
            _errortext = '';
            _isSignedIn = true;
            prefs.setBool('isSignedIn', true);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).popUntil((route) => route.isFirst);
            });
            _logger.d('Sign In Succeeded');
          } else {
            _logger.e('Username Or Password Is Incorrect');
          }
        } else {
          _logger.e('No Stored Credentials Found');
        }
      } else {
        _logger.e('Username And Password Cannot Be Empty');
      }
    } catch (e) {
      _logger.e('An Error Occured: $e');
    }
  }

  Future<Map<String, String>> _retrieveAndDecryptDataFromPrefs(
    Future<SharedPreferences> prefs,
  ) async {
    final sharedPreferences = await prefs;
    final encryptedUsername = sharedPreferences.getString('username') ?? '';
    final encryptedPassword = sharedPreferences.getString('password') ?? '';
    final keyString = sharedPreferences.getString('key') ?? '';
    final ivString = sharedPreferences.getString('iv') ?? '';

    final encrypt.Key key = encrypt.Key.fromBase64(keyString);
    final iv = encrypt.IV.fromBase64(ivString);

    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final decryptedUsername = encrypter.decrypt64(encryptedUsername, iv: iv);
    final decryptedPassword = encrypter.decrypt64(encryptedPassword, iv: iv);

    return {'username': decryptedUsername, 'password': decryptedPassword};
  }
}
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar : AppBar(
        title : const Text('Home'),
      ),
      body: const Center(
        child: Text('Welcome !'),
      ),
    );
  }
}