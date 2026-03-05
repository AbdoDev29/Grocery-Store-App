import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:shop/consts/firebase_consts.dart';
import 'package:shop/inner_screens/product_details.dart';
import 'package:shop/models/products_model.dart';
import 'package:shop/providers/cart_provider.dart';
import 'package:shop/providers/viewed_prod_provider.dart';
import 'package:shop/providers/wishlist_provider.dart';
import 'package:shop/services/global_methods.dart';
import 'package:shop/services/utils.dart';
import 'package:shop/widgets/heart_btn.dart';
import 'package:shop/widgets/text_widget.dart';

import 'price_widget.dart';

class OnSaleWidget extends StatefulWidget {
  const OnSaleWidget({Key? key}) : super(key: key);

  @override
  State<OnSaleWidget> createState() => _OnSaleWidgetState();
}

class _OnSaleWidgetState extends State<OnSaleWidget> {
  @override
  Widget build(BuildContext context) {
    final productModle = Provider.of<ProductModel>(context);
    final Color color = Utils(context).color;
    final theme = Utils(context).getTheme;
    Size size = Utils(context).getScreenSize;
    final cartProvider = Provider.of<CartProvider>(context);
    bool? _isInCart = cartProvider.getCartItems.containsKey(productModle.id);
    final wishlistProvider = Provider.of<WishlistProvider>(context);

    bool? _isInWishlist = wishlistProvider.getwishlistItems.containsKey(
      productModle.id,
    );
    final viewedProdProvider = Provider.of<ViewedProdProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            viewedProdProvider.addProductToHistory(productId: productModle.id);
            Navigator.pushNamed(
              context,
              ProductDetails.routeName,
              arguments: productModle.id,
            );
            // GlobalMethods.navigateTo(
            //   ctx: context,
            //   routeName: ProductDetails.routeName,
            // );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FancyShimmerImage(
                      imageUrl: productModle.imageUrl,
                      height: size.width * 0.22,
                      width: size.width * 0.22,
                      boxFit: BoxFit.fill,
                    ),
                    Column(
                      children: [
                        TextWidget(
                          text: productModle.isPiece ? '1Peace' : '1KG',
                          color: color,
                          textSize: 22,
                          isTitle: true,
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: _isInCart
                                  ? null
                                  : () async {
                                      final User? user =
                                          authInstance.currentUser;
                                      if (user == null) {
                                        // print('user id is: ${user!.uid}');
                                        GlobalMethods.errorDialog(
                                          subtitle:
                                              'No user found, Please login first',
                                          context: context,
                                        );
                                        return;
                                      }
                                      await GlobalMethods.addToCart(
                                        productId: productModle.id,
                                        quantity: 1,
                                        context: context,
                                      );
                                      await cartProvider.fetchCart();

                                      // cartProvider.addProductsToCart(
                                      //   productId: productModle.id,
                                      //   quantity: 1,
                                      // );
                                    },
                              child: Icon(
                                _isInCart ? IconlyBold.bag2 : IconlyLight.bag2,
                                size: 22,
                                color: _isInCart ? Colors.green : color,
                              ),
                            ),
                            HeartBTN(
                              productId: productModle.id,
                              isInWishlist: _isInWishlist,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                PriceWidget(
                  isOnSale: true,
                  price: productModle.price,
                  salePrice: productModle.salePrice,
                  textPrice: '1',
                ),
                const SizedBox(height: 5),
                TextWidget(
                  text: productModle.title,
                  color: color,
                  textSize: 16,
                  isTitle: true,
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
