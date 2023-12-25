import 'package:flutter/material.dart';
import 'package:piknikplg_uas_pab/data/wisataplg_data.dart';
import 'package:piknikplg_uas_pab/models/wisataplg.dart';
import 'package:piknikplg_uas_pab/widget/app_color.dart' as warna;

class MenuUtama extends StatefulWidget {
  const MenuUtama({super.key});

  @override
  State<MenuUtama> createState() => _MenuUtamaState();
}

class _MenuUtamaState extends State<MenuUtama> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: warna.primary,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Image.asset(
              'images/logo.png',
              fit: BoxFit.contain,
              height: 30,
            ),
            actions: [
              InkWell(
                onTap: () {
                  debugPrint("Gambar telah ditekan");
                },
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: ClipOval(
                    child: Image.asset(
                      "images/placeholder_image.png",
                      color: Colors.black,
                    ),
                  ),
                ),
              )
            ],
          ),
          body: Column(
            children: [
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 10, left: 10),
                    child: const Text(
                      "Tempat Populer",
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 180,
                child: Stack(
                  children: [
                    Positioned(
                        top: 0,
                        left: -20,
                        right: 0,
                        child: Container(
                          height: 180,
                          child: PageView.builder(
                            controller: PageController(viewportFraction: 0.8),
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              WisataPlg wisataPlg = wisataList[index];
                              return Container(
                                height: 180,
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(
                                      image: AssetImage(wisataPlg.imageAsset),
                                      fit: BoxFit.fill),
                                ),
                              );
                            },
                          ),
                        ))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
