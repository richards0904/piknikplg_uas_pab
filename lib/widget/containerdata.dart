import 'package:flutter/material.dart';
import 'package:piknikplg_uas_pab/data/wisataplg_data.dart';
import 'package:piknikplg_uas_pab/widget/app_color.dart' as warna;

class CardContainer extends StatelessWidget {
  final String kategoris;
  const CardContainer({super.key, required this.kategoris});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount:
          wisataList.where((tempat) => tempat.kategori == kategoris).length,
      itemBuilder: (context, index) {
        List kategoriList =
            wisataList.where((tempat) => tempat.kategori == kategoris).toList();
        return InkWell(
          onTap: () {},
          child: Container(
            margin:
                const EdgeInsets.only(left: 10, bottom: 10, right: 20, top: 10),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: warna.tabViewColor,
                boxShadow: [
                  BoxShadow(
                      blurRadius: 2,
                      offset: const Offset(0, 0),
                      color: Colors.grey.withOpacity(0.2))
                ],
              ),
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          width: 150,
                          height: 120,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  image: AssetImage(
                                      kategoriList[index].imageAsset))),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  kategoriList[index].name,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                )),
                              ],
                            )
                          ],
                        ),
                      )
                    ]),
              ),
            ),
          ),
        );
      },
    );
  }
}
