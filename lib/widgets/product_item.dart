import 'package:baftopia/models/product.dart';
import 'package:baftopia/screens/product_detail.dart';
import 'package:baftopia/utils/persian_number.dart';
import 'package:baftopia/widgets/add_product.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({super.key, required this.product, required this.duration});

  final ProductModel product;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    Difficulty difficultyFromString(String value) {
      return Difficulty.values.firstWhere(
        (d) => d.name == value,
        orElse: () => Difficulty.beginner,
      );
    }

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (ctx) => ProductDetail(product: product)),
        );
      },
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(33, 88, 81, 81),
              offset: Offset(0, 2),
              blurRadius: 4,
              spreadRadius: 0,
            ),
          ],
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: ListTile(
          style: ListTileStyle.list,
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: FadeInImage(
              placeholder: MemoryImage(kTransparentImage),
              image: NetworkImage(product.image),
              width: 54,
              height: 54,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(
            product.title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            difficultyFromString(product.difficultyLevel).persianLabel,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          trailing: Text.rich(
            TextSpan(
              text: 'مدت زمان بافت: ',
              children: [
                TextSpan(
                  text:
                      duration.inDays < 1
                          ? '${PersianNumber.toPersian(duration.inHours.toString())} ساعت'
                          : '${PersianNumber.toPersian(duration.inDays.toString())} روز',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
