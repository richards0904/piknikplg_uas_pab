import 'dart:io';

import 'package:flutter/material.dart';
import 'package:piknikplg_uas_pab/widget/profile_info_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:piknikplg_uas_pab/widget/app_color.dart' as warna;
import 'package:logger/logger.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // TODO : 1. Deklarasikan variabel yang dibutuhkan
  String _imageFile = '';
  final picker = ImagePicker();
  bool isSignedin = false;
  String fullname = "";
  String username = "";
  int favoriteCandiCount = 0;
  final Logger _logger = Logger();

  Future<void> _getImage(ImageSource source) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      prefs.setString("profile_image_path", pickedFile.path);
      setState(() {
        _imageFile = prefs.getString("profile_image_path") ?? '';
      });
    }
  }

  void _showPicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ListTile(
              title: Text(
                "Image Source",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.photo_library,
              ),
              title: const Text("Gallery"),
              onTap: () {
                Navigator.of(context).pop();
                _getImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.photo_library,
              ),
              title: const Text("Camera"),
              onTap: () {
                Navigator.of(context).pop();
                _getImage(ImageSource.camera);
              },
            ),
          ],
        );
      },
    );
  }

  void _loadProfilePhoto() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _imageFile = prefs.getString("profile_image_path") ?? '';
    });
  }

  void _editFullName() {
    String newName = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Nama'),
          content: TextFormField(
            decoration: const InputDecoration(
              hintText: 'Masukkan nama baru',
            ),
            onChanged: (value) {
              newName = value;
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Simpan'),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                final keyString = prefs.getString('key') ?? '';
                final ivString = prefs.getString('iv') ?? '';

                final encrypt.Key key = encrypt.Key.fromBase64(keyString);
                final iv = encrypt.IV.fromBase64(ivString);
                final encrypter = encrypt.Encrypter(encrypt.AES(key));
                if (newName.isNotEmpty) {
                  final encryptedFullname = encrypter.encrypt(newName, iv: iv);
                  prefs.setString('fullname', encryptedFullname.base64);
                  setState(() {
                    fullname = newName;
                  });
                  Navigator.of(context).pop();
                } else {
                  _showAlertDialog();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showAlertDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Peringatan'),
          content: const Text("Nama Tidak Boleh Kosong"),
          actions: <Widget>[
            TextButton(
              child: const Text('Tutup'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _retrieveAndDecryptDataFromPrefs() async {
    final Future<SharedPreferences> prefsFuture =
        SharedPreferences.getInstance();
    final SharedPreferences sharedPreferences = await prefsFuture;

    final encryptedUsername = sharedPreferences.getString('username') ?? '';
    final encryptedFullname = sharedPreferences.getString('fullname') ?? '';
    final keyString = sharedPreferences.getString('key') ?? '';
    final ivString = sharedPreferences.getString('iv') ?? '';

    final encrypt.Key key = encrypt.Key.fromBase64(keyString);
    final iv = encrypt.IV.fromBase64(ivString);

    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    if (encryptedFullname != "") {
      final decryptedUsername = encrypter.decrypt64(encryptedUsername, iv: iv);
      final decryptedFullname = encrypter.decrypt64(encryptedFullname, iv: iv);

      setState(() {
        username = decryptedUsername;
        fullname = decryptedFullname;
      });
    }
  }

  void _signOutLocalStorage() async {
    try {
      final Future<SharedPreferences> prefsFuture =
          SharedPreferences.getInstance();

      final SharedPreferences prefs = await prefsFuture;
      prefs.setBool('isSignedIn', false);
      prefs.setString('fullname', "");
      prefs.setString('username', "");
      prefs.setString('password', "");
      prefs.setString('key', "");
      prefs.setString('iv', "");
      prefs.setInt('jumlahFavorit', 0);
      prefs.setString("profile_image_path", '');

      setState(() {
        fullname = "";
        username = "";
        isSignedin = false;
        favoriteCandiCount = 0;
      });
    } catch (e) {
      _logger.d('An error occurred: $e');
    }
  }

  void _signInLocalStorage() async {
    try {
      final Future<SharedPreferences> prefsFuture =
          SharedPreferences.getInstance();
      final SharedPreferences prefs = await prefsFuture;
      prefs.setString('fullname', fullname);
      prefs.setString('username', username);
      setState(() {
        fullname = fullname;
        username = username;
      });
      _checkIn();
    } catch (e) {
      _logger.d('An error occurred: $e');
    }
  }

  // TODO : 5. Implementasi fungsi Signin
  void signIn() {
    setState(() {
      Navigator.pushNamed(context, '/signin');
      _signInLocalStorage();
    });
  }

  void _checkIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool signedIn = prefs.getBool('isSignedIn') ?? false;

    setState(() {
      isSignedin = signedIn;
    });
  }

  void _loadFavoriteCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int jumlahFavorit = prefs.getInt('jumlahFavorit') ?? 0;
    setState(() {
      favoriteCandiCount = jumlahFavorit;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkIn();
    _retrieveAndDecryptDataFromPrefs();
    _loadFavoriteCount();
    _loadProfilePhoto();
  }

  // TODO : 6. Implementasi fungsi Signout
  void signOut() {
    setState(() {
      _signOutLocalStorage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wisata Candi'),
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
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: 200,
              width: double.infinity,
              color: warna.primary,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  // TODO : 2. Buat bagian ProfileHeader yang berisi gambar profil
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 200 - 50),
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: warna.primary, width: 2),
                              shape: BoxShape.circle,
                            ),
                            child: CircleAvatar(
                                radius: 50,
                                backgroundImage:
                                    _imageFile.isNotEmpty && isSignedin
                                        ? FileImage(File(_imageFile))
                                            as ImageProvider
                                        : const AssetImage(
                                            'images/placeholder_image.png')),
                          ),
                          if (isSignedin)
                            IconButton(
                              onPressed: () {
                                _showPicker();
                              },
                              icon: const Icon(
                                Icons.camera_alt,
                                color: Colors.black,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  // TODO : 3. Buat bagian Profileinfo yang berisi info profil
                  const SizedBox(
                    height: 20,
                  ),
                  Divider(
                    color: warna.primaryShade,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  ProfileInfoItem(
                      icon: Icons.mail_rounded,
                      label: 'Username',
                      value: username,
                      iconColor: Colors.amber),
                  const SizedBox(
                    height: 4,
                  ),
                  Divider(
                    color: warna.primaryShade,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  ProfileInfoItem(
                      icon: Icons.person,
                      label: 'Nama',
                      value: fullname,
                      showEditIcon: isSignedin,
                      onEditPressed: () {
                        _editFullName();
                      },
                      iconColor: Colors.blue),
                  const SizedBox(
                    height: 4,
                  ),
                  Divider(
                    color: warna.primaryShade,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  ProfileInfoItem(
                      icon: Icons.favorite,
                      label: 'Favorit',
                      value:
                          favoriteCandiCount > 0 ? '$favoriteCandiCount' : '-',
                      iconColor: Colors.red),
                  // TODO : 4. Buat ProfileActions yang berisi TextButton sign in/out
                  const SizedBox(
                    height: 4,
                  ),
                  Divider(
                    color: warna.primaryShade,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  isSignedin
                      ? ElevatedButton(
                          onPressed: signOut,
                          child: const Text(
                            'Sign out',
                            style: TextStyle(color: Colors.white),
                          ))
                      : ElevatedButton(
                          onPressed: signIn,
                          child: const Text('Sign In',
                              style: TextStyle(color: Colors.white))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
