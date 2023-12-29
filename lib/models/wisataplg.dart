class WisataPlg {
  final String name;
  final String location;
  final String maps;
  final String description;
  final String type;
  final String imageAsset;
  final List<String> imageUrls;
  bool isFavorite;
  final String kategori;

  WisataPlg({
    required this.name,
    required this.location,
    required this.maps,
    required this.description,
    required this.type,
    required this.imageAsset,
    required this.imageUrls,
    this.isFavorite = false,
    required this.kategori,
  });

  void add(item) {}

  void remove(item) {}
}
