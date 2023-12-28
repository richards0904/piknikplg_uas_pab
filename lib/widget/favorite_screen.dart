import 'package:flutter/material.dart';
import 'package:piknikplg_uas_pab/data/wisataplg_data.dart';
import 'package:piknikplg_uas_pab/models/wisataplg.dart';
import 'package:piknikplg_uas_pab/widget/detail_screen.dart';

class FavoriteWisata extends StatefulWidget {
  const FavoriteWisata({super.key});

  @override
  State<FavoriteWisata> createState() => _FavoriteWisataState();
}

class _FavoriteWisataState extends State<FavoriteWisata> {
  List<WisataPlg> _filteredWisata = [];

  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorit Wisata"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.deepPurple[50],
              ),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Cari Wisata...',
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurple),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onChanged: (query) {
                  setState(() {
                    _searchQuery = query.toLowerCase();
                    _filteredWisata = wisataList
                        .where((WisataPlg) =>
                            WisataPlg.name
                                .toLowerCase()
                                .contains(_searchQuery) ||
                            WisataPlg.location
                                .toLowerCase()
                                .contains(_searchQuery))
                        .toList();
                  });
                },
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: _searchQuery.isEmpty
                      ? wisataList.length
                      : _filteredWisata.length,
                  itemBuilder: (context, index) {
                    final wisataPencarian = _searchQuery.isEmpty
                        ? wisataList[index]
                        : _filteredWisata[index];
                    if (wisataPencarian.isFavorite) {
                      return Container(
                        decoration: BoxDecoration(
                            // color: const Color.fromRGBO(35, 39, 52, 1),
                            color: const Color.fromRGBO(255, 255, 255, 1),
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
                                image: AssetImage(wisataPencarian.imageAsset),
                              ),
                            ),
                          ),
                          // onTap: () {
                          //   Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (context) => DetailScreen(
                          //         wisataPlg,
                          //         onFavoriteChange: (isFavorite) {
                          //           wisataPencarian.isFavorite = isFavorite;
                          //         },
                          //       ),
                          //     ),
                          //   ).then((_) => {
                          //         setState(() {
                          //           _filteredWisata = wisataList
                          //               .where((wisata) => wisata.isFavorite)
                          //               .toList();
                          //         })
                          //       }); // Tindakan yang akan dijalankan saat item di klik
                          // },
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  }))
        ],
      ),
    );
  }
}
