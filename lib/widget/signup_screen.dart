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
  bool _obscurePassword = true;

  void _performSignUp(BuildContext context) async {
    try {
      final prefs = SharedPreferences.getInstance();
      _logger.d('Percobaan Sign up');
      final String fullname = _fullnameController.text.trim();
      final String username = _usernameController.text.trim();
      final String password = _passwordController.text.trim();

      if (password.length < 8 ||
          !password.contains(RegExp(r'[A-Z]')) ||
          !password.contains(RegExp(r'[a-z]')) ||
          !password.contains(RegExp(r'[0-9]')) ||
          !password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
        setState(() {
          _errorText =
              'Password minimal 8 karakter, kombinasi [A-Z],[a-z],[0-9], [!@#%^&*(),.?":{}|<>]';
        });
        return;
      }

      if (username != '' && fullname != '' && password != '') {
        final encrypt.Key key = encrypt.Key.fromLength(32);
        final iv = encrypt.IV.fromLength(16);
        final encrypter = encrypt.Encrypter(encrypt.AES(key));
        final encryptedUsername = encrypter.encrypt(username, iv: iv);
        final encryptedFullname = encrypter.encrypt(fullname, iv: iv);
        final encryptedPassword = encrypter.encrypt(password, iv: iv);

        _saveEncryptedDataToPrefs(
          prefs,
          encryptedUsername.base64,
          encryptedFullname.base64,
          encryptedPassword.base64,
          key.base64,
          iv.base64,
        ).then((_) {
          Navigator.pop(context);
          _logger.d('Berhasil Sign up');
        });
      } else {
        setState(() {
          _errorText = "Username, FullName dan password tidak boleh kosong";
        });
        _logger.e('Username atau password tidak boleh kosong');
      }
    } catch (e) {
      _logger.e('Terjadi Kesalahan: $e');
    }
  }

  Future<void> _saveEncryptedDataToPrefs(
    Future<SharedPreferences> prefs,
    String encryptedUsername,
    String encryptedFullname,
    String encryptedPassword,
    String keyString,
    String ivString,
  ) async {
    final sharedPreferences = await prefs;
    _logger.d('Saving user data to SharedPreferences');
    await sharedPreferences.setString('username', encryptedUsername);
    await sharedPreferences.setString('fullname', encryptedFullname);
    await sharedPreferences.setString('password', encryptedPassword);
    await sharedPreferences.setString('key', keyString);
    await sharedPreferences.setString('iv', ivString);
  }

  @override
  void dispose() {
    _fullnameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
                  Image.asset(
                    "images/logo.png",
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  TextFormField(
                    controller: _fullnameController,
                    decoration: const InputDecoration(
                      labelText: "Nama Lengkap",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
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
                  Text(
                    _errorText,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _performSignUp(context);
                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20),
                  RichText(
                    text: TextSpan(
                      text: 'Sudah Punya Akun ? Klik ',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Disini',
                          style: const TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                            fontSize: 16,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pop(context);
                            },
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
}
