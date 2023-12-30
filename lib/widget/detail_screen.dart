import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:piknikplg_uas_pab/models/wisataplg.dart';
import 'package:piknikplg_uas_pab/widget/favorite_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:piknikplg_uas_pab/widget/app_color.dart' as warna;

class DetailScreen extends StatefulWidget {
  final WisataPlg wisataPlg;

  const DetailScreen({super.key, required this.wisataPlg});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool isFavorite = false;
  bool isSignedIn = false;

  void _checkIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool signedIn = prefs.getBool('isSignedIn') ?? false;

    setState(() {
      isSignedIn = signedIn;
    });
  }

  void _loadFavouriteStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool favorite = prefs.getBool('favorite_${widget.wisataPlg.name}') ?? false;

    setState(() {
      //print(favorite);
      isFavorite = favorite;
    });
  }

  Future<void> _toggleFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!isSignedIn) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Navigator.pushReplacementNamed(context, "/signin");
      });
      return;
    }

    bool favoriteStatus = !isFavorite;
    prefs.setBool('favorite_${widget.wisataPlg.name}', favoriteStatus);

    setState(() {
      isFavorite = favoriteStatus;
      print(isFavorite);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        widget.wisataPlg.imageAsset,
                        width: double.infinity,
                        height: 300,
                        fit: BoxFit.cover,
                      ),
                    )),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                  child: Container(
                    decoration: BoxDecoration(
                        color:
                            Color.fromARGB(255, 255, 255, 255).withOpacity(0.7),
                        shape: BoxShape.circle),
                    child: IconButton(
                        onPressed: () {
                          Navigator.pop(context, isFavorite);
                        },
                        icon: const Icon(Icons.arrow_back)),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.wisataPlg.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            _toggleFavorite();
                          },
                          icon: Icon(isSignedIn && isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border),
                          color: isSignedIn && isFavorite ? Colors.red : null),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      const Icon(Icons.place, color: Colors.red),
                      const SizedBox(
                        width: 8,
                      ),
                      const SizedBox(
                        width: 70,
                        child: Text(
                          'Lokasi    :',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                          child: Text(
                        widget.wisataPlg.location,
                        textAlign: TextAlign.justify,
                      ))
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.category, color: Colors.blue),
                      const SizedBox(
                        width: 8,
                      ),
                      const SizedBox(
                        width: 70,
                        child: Text(
                          'Kategori :',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(widget.wisataPlg.kategori)
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(
                        Icons.type_specimen,
                        color: Colors.green,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      const SizedBox(
                        width: 70,
                        child: Text(
                          'Tipe        :',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(widget.wisataPlg.type)
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Divider(color: warna.primary),
                  const SizedBox(
                    height: 16,
                  ),
                  const Text(
                    'Deskripsi',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(widget.wisataPlg.description,
                      textAlign: TextAlign.justify),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(color: warna.primary),
                  const Text(
                    'Galeri',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                      height: 100,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.wisataPlg.imageUrls.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(right: 8),
                              child: GestureDetector(
                                onTap: () {},
                                child: Container(
                                  decoration: BoxDecoration(),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          widget.wisataPlg.imageUrls[index],
                                      width: 120,
                                      height: 120,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Container(
                                        width: 120,
                                        height: 120,
                                        color: Colors.deepPurple[50],
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          })),
                  const SizedBox(
                    height: 4,
                  ),
                  const Text('Tap untuk memperbesar')
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkIn();
    _loadFavouriteStatus();
  }
}
