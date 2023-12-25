// ignore_for_file: unused_field, unused_local_variable, unused_element, prefer_typing_uninitialized_variables

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final Logger _logger = Logger();

  String _errorText = '';
  final bool _isSignedUp = false;
  bool _obscurePassword = true;

  void _signUp() {
    String fullname = _fullnameController.text.trim();
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    if (password.length < 8 ||
        !password.contains(RegExp(r'[A-Z]')) ||
        !password.contains(RegExp(r'[a-z]')) ||
        !password.contains(RegExp(r'[0-9]')) ||
        !password.contains(RegExp(r'[@#$%^&*(),.?":{}|<>]'))) {
      setState(() {
        _errorText =
            'Password minimal 8 karakter, kombinasi [A-Z],[a-z],[0-9], [@#%^&*(),.?":{}|<>]';
      });
      return;
    }

    if (fullname.isNotEmpty && username.isNotEmpty && password.isNotEmpty) {
      final encrypt.Key key = encrypt.Key.fromLength(32);
      final iv = encrypt.IV.fromLength(16);

      final encrypter = encrypt.Encrypter(encrypt.AES(key));
      final encryptedFullname = encrypter.encrypt(fullname, iv: iv);
      final encryptedUsername = encrypter.encrypt(username, iv: iv);
      final encryptedPassword = encrypter.encrypt(password, iv: iv);

      var prefs;
      prefs.setString('fullname', encryptedFullname.base64);
      prefs.setString('username', encryptedUsername.base64);
      prefs.setstring('password', encryptedPassword.base64);
      prefs.setString('key', key.base64);
      prefs.setString('iv', iv.base64);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
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
                    controller: _fullnameController,
                    decoration: const InputDecoration(
                      labelText: "fullname",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: "username",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: "password",
                      errorText: _errorText.isNotEmpty ? _errorText : null,
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
                      _performSignUp(context);
                    },
                    child: const Text('Sign Up'),
                  ),
                  const SizedBox(height: 20),
                  RichText(
                    text: TextSpan(
                      text: 'Already have an account ?',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: ' Sign In.',
                          style: const TextStyle(
                            color: Colors.black,
                            decoration: TextDecoration.underline,
                            fontSize: 16,
                          ),
                          recognizer: TapGestureRecognizer()..onTap = () {},
                        ),
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

  void _performSignUp(BuildContext context) {
    try {
      final prefs = SharedPreferences.getInstance();
      _logger.d('Sign up attempt');
      final String fullname = _fullnameController.text;
      final String username = _usernameController.text;
      final String password = _passwordController.text;

      if (username.isNotEmpty && password.isNotEmpty) {
        final encrypt.Key key = encrypt.Key.fromLength(32);
        final iv = encrypt.IV.fromLength(16);
        final encrypter = encrypt.Encrypter(encrypt.AES(key));
        final encryptedUsername = encrypter.encrypt(username, iv: iv);
        final encryptedPassword = encrypter.encrypt(password, iv: iv);

        _saveEncryptedDataToPrefs(
          prefs,
          encryptedUsername.base64,
          encryptedPassword.base64,
          key.base64,
          iv.base64,
        ).then((_) {
          Navigator.pop(context);
          _logger.d('Sign up succeeded');
        });
      } else {
        _logger.e('Username or password cannot be empty');
      }
    } catch (e) {
      _logger.e('An Error Occured: $e');
    }
  }

  Future<void> _saveEncryptedDataToPrefs(
    Future<SharedPreferences> prefs,
    String encryptedUsername,
    String encryptedPassword,
    String keyString,
    String ivString,
  ) async {
    final sharedPreferences = await prefs;
    _logger.d('Saving user data to SharedPreferences');
    await sharedPreferences.setString('username', encryptedUsername);
    await sharedPreferences.setString('password', encryptedPassword);
    await sharedPreferences.setString('key', keyString);
    await sharedPreferences.setString('iv', ivString);
  }
}
