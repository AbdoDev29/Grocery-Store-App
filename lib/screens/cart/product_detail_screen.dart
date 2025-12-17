import 'package:flutter/material.dart';
import 'package:shop/services/utils.dart';
import 'package:shop/widgets/heart_btn.dart';
import 'package:shop/widgets/text_widget.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;

    // Size size = Utils(context).getScreenSize;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.backpack),
          ),
        ],
      ),
      body: Column(
        children: [
          Image.network('https://i.ibb.co/F0s3FHQ/Apricots.png'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              children: [
                TextWidget(
                  text: 'Cucumbers',
                  color: color,
                  textSize: 22,
                  isTitle: true,
                ),
                const Spacer(),
                // HeartBTN(
                //         productId: productModle.id,
                //         isInWishlist: _isInWishlist,
                //       ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                TextWidget(
                  text: '\$0.99',
                  color: Colors.green,
                  textSize: 18,
                  isTitle: true,
                ),
                Spacer(),
                Material(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.green,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextWidget(
                      text: 'Free delivery',
                      color: Colors.white,
                      textSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
