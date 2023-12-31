import 'package:flutter/material.dart';
import 'package:piknikplg_uas_pab/data/wisataplg_data.dart';
import 'package:piknikplg_uas_pab/models/wisataplg.dart';
import 'package:piknikplg_uas_pab/widget/detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteWisata extends StatefulWidget {
  const FavoriteWisata({super.key});

  @override
  State<FavoriteWisata> createState() => FavoriteWisataState();
}

class FavoriteWisataState extends State<FavoriteWisata> {
  List<WisataPlg> filteredWisata = [];
  int jumlahFavorit = 0;
  bool isSignedIn = false;

  void _checkIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool signedIn = prefs.getBool('isSignedIn') ?? false;

    setState(() {
      isSignedIn = signedIn;
    });
  }

  void _loadFavoritePlaces() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoritePlaces = [];
    // Ambil semua kunci yang dimulai dengan 'favorite_'
    Set<String> keys = prefs.getKeys();
    for (String key in keys) {
      if (key.startsWith('favorite_')) {
        // Jika tempat tersebut difavoritkan, tambahkan nama tempat ke daftar favorit
        if (prefs.getBool(key) ?? false) {
          favoritePlaces
              .add(key.substring(9)); // Menghapus 'favorite_' dari kunci
        }
      }

      setState(() {
        // Filter wisataList berdasarkan nama tempat yang ada di daftar favorit
        filteredWisata = wisataList
            .where((wisata) => favoritePlaces.contains(wisata.name))
            .toList();
        jumlahFavorit = filteredWisata.length;
      });
    }
  }

  void countFavorite() async {
    SharedPreferences simpan = await SharedPreferences.getInstance();
    simpan.setInt("jumlahFavorit", jumlahFavorit);
  }

  @override
  void initState() {
    super.initState();
    _checkIn();
    _loadFavoritePlaces();
    if (isSignedIn) {
      countFavorite();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorit Wisata"),
      ),
      body: !isSignedIn
          ? const Center(
              child: Text(
                'Silahkan Sign In Dahulu',
                style: TextStyle(fontSize: 18),
              ),
            )
          : filteredWisata.isEmpty
              ? const Center(
                  child: Text(
                    'Daftar Favorit Kosong',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                        child: ListView.builder(
                            itemCount: filteredWisata.length,
                            itemBuilder: (context, index) {
                              final wisataPencarian = filteredWisata[index];
                              return Container(
                                decoration: BoxDecoration(
                                    // color: const Color.fromRGBO(35, 39, 52, 1),
                                    color:
                                        const Color.fromRGBO(255, 255, 255, 1),
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 3,
                                        blurRadius: 5,
                                        offset: const Offset(
                                            0, 1), // changes position of shadow
                                      ),
                                    ]),
                                margin: const EdgeInsets.only(
                                    left: 15, right: 15, bottom: 15),
                                child: ListTile(
                                  title: Text(
                                    wisataPencarian.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      // color: Color.fromRGBO(148, 155, 167, 1),
                                    ),
                                  ),
                                  subtitle: Text(
                                    wisataPencarian.location,
                                    style: const TextStyle(
                                      color: Color.fromRGBO(148, 155, 167, 1),
                                    ),
                                  ),
                                  trailing: const Icon(Icons.navigate_next),
                                  leading: Container(
                                    width:
                                        80, // Set the width to increase the size of the leading image
                                    height:
                                        80, // Set the height to increase the size of the leading image
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage(
                                            wisataPencarian.imageAsset),
                                      ),
                                    ),
                                  ),
                                  onTap: () async {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailScreen(
                                            wisataPlg: filteredWisata[index]),
                                      ),
                                    ).then((isFavorite) => {
                                          setState(() {
                                            _loadFavoritePlaces();
                                            countFavorite();
                                          })
                                        }); // Tindakan yang akan dijalankan saat item di klik
                                  },
                                ),
                              );
                            }))
                  ],
                ),
    );
  }
}
