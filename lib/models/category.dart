class Category {
  const Category({
    required this.title,
    required this.image,
    this.isFromAsset = true,
  });

  final String title;
  final String image;
  final bool isFromAsset;
}
