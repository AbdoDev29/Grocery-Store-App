import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:shop/inner_screens/product_details.dart';
import 'package:shop/models/wishlish_model.dart';
import 'package:shop/providers/product_provider.dart';
import 'package:shop/providers/wishlist_provider.dart';
import 'package:shop/services/utils.dart';
import 'package:shop/widgets/heart_btn.dart';
import 'package:shop/widgets/text_widget.dart';

class WishlistWidget extends StatelessWidget {
  const WishlistWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final wishlistModel = Provider.of<WishlishModel>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);

    final productProvider = Provider.of<ProductProvider>(context);
    final getCurrProduct = productProvider.findProdById(
      wishlistModel.productId,
    );

    double usedPrice = getCurrProduct.isOnSale
        ? getCurrProduct.salePrice
        : getCurrProduct.price;

    bool? _isInWishlist = wishlistProvider.getwishlistItems.containsKey(
      getCurrProduct.id,
    );
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            ProductDetails.routeName,
            arguments: wishlistModel.productId,
          );
        },
        child: Container(
          height: size.height * 0.15,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            border: Border.all(color: color, width: 1),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            children: [
              Flexible(
                flex: 2,
                child: Container(
                  margin: const EdgeInsets.only(left: 8),
                  // width: size.width * 0.2,
                  height: size.width * 0.25,
                  child: FancyShimmerImage(
                    imageUrl: getCurrProduct.imageUrl,

                    boxFit: BoxFit.contain,
                  ),
                ),
              ),
              Flexible(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Row(
                        children: [
                          // IconButton(
                          //   onPressed: () {},
                          //   icon: Icon(
                          //     IconlyLight.bag2,
                          //     color: color,
                          //   ),
                          // ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 50.0,

                              vertical: 15.0,
                            ),
                            child: HeartBTN(
                              productId: getCurrProduct.id,
                              isInWishlist: _isInWishlist,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    Flexible(
                      flex: 3,
                      child: TextWidget(
                        text: getCurrProduct.title,
                        color: color,
                        textSize: 20.0,
                        maxLines: 1,
                        isTitle: true,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextWidget(
                      text: '\$${usedPrice.toStringAsFixed(2)}',
                      color: color,
                      textSize: 18.0,
                      maxLines: 1,
                      isTitle: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
