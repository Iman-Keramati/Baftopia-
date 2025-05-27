class Category {
  const Category({required this.id, required this.title, required this.image});

  final String id;
  final String title;
  final String image;

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      title: json['title'] as String,
      image: json['image'] as String,
    );
  }
}
