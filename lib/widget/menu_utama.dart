import 'package:flutter/material.dart';
import 'package:piknikplg_uas_pab/data/wisataplg_data.dart';
import 'package:piknikplg_uas_pab/models/wisataplg.dart';
import 'package:piknikplg_uas_pab/widget/app_tabs.dart';
import 'package:piknikplg_uas_pab/widget/app_color.dart' as warna;
import 'package:piknikplg_uas_pab/widget/containerdata.dart';
import 'package:piknikplg_uas_pab/widget/profile_screen.dart';

class MenuUtama extends StatefulWidget {
  const MenuUtama({super.key});

  @override
  State<MenuUtama> createState() => _MenuUtamaState();
}

class _MenuUtamaState extends State<MenuUtama>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;
  

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _scrollController = ScrollController();
  }

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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileScreen(),
                      ));
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
                      "Tempat Terpopuler",
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
                        )),
                  ],
                ),
              ),
              Expanded(
                  child: NestedScrollView(
                body: TabBarView(
                  controller: _tabController,
                  children: [
                    CardContainer(kategoris: "Sejarah"),
                    CardContainer(kategoris: "Alam"),
                    CardContainer(kategoris: "Rekreasi"),
                  ],
                ),
                controller: _scrollController,
                headerSliverBuilder: (BuildContext context, bool isScrool) {
                  return [
                    SliverAppBar(
                      pinned: true,
                      backgroundColor: Colors.white,
                      bottom: PreferredSize(
                        preferredSize: const Size.fromHeight(50),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 20, left: 10),
                          child: TabBar(
                            tabs: [
                              AppTabs(color: warna.menu1Color, text: "Sejarah"),
                              AppTabs(color: warna.menu2Color, text: "Alam"),
                              AppTabs(color: warna.menu3Color, text: "Rekreasi")
                            ],
                            indicatorPadding: const EdgeInsets.all(0),
                            indicatorSize: TabBarIndicatorSize.label,
                            labelPadding: const EdgeInsets.only(right: 5),
                            controller: _tabController,
                            isScrollable: true,
                            indicator: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      blurRadius: 7,
                                      offset: const Offset(0, 0))
                                ]),
                          ),
                        ),
                      ),
                    )
                  ];
                },
              ))
            ],
          ),
        ),
      ),
    );
  }
}
