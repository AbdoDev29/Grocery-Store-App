import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:shop/widgets/price_widget.dart';
import 'package:shop/widgets/text_widget.dart';

class FeedsWidget extends StatefulWidget {
  const FeedsWidget({
    super.key,
  });

  @override
  State<FeedsWidget> createState() => _FeedsWidgetState();
}

class _FeedsWidgetState extends State<FeedsWidget> {
  final _quantityTextController = TextEditingController();

  @override
  void initState() {
    _quantityTextController.text = '1';
    super.initState();
  }

  @override
  void dispose() {
    _quantityTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    final Color color = Utils(context).color;
    final productModle = Provider.of<ProductModel>(context);
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
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).cardColor,
        child: InkWell(
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
          borderRadius: BorderRadius.circular(12),
          child: Column(
            children: [
              FancyShimmerImage(
                imageUrl: productModle.imageUrl,
                height: size.width * 0.21,
                width: size.width * 0.2,
                boxFit: BoxFit.fill,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  // vertical: 5,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 3,
                      child: TextWidget(
                        text: productModle.title,
                        color: color,
                        textSize: 18,
                        isTitle: true,
                        maxLines: 1,
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: HeartBTN(
                        productId: productModle.id,
                        isInWishlist: _isInWishlist,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 3,
                      child: PriceWidget(
                        isOnSale: productModle.isOnSale,
                        price: productModle.price,
                        salePrice: productModle.salePrice,
                        textPrice: _quantityTextController.text,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Row(
                        children: [
                          Flexible(
                            flex: 3,
                            child: FittedBox(
                              child: TextWidget(
                                text: productModle.isPiece ? 'Piece' : 'kg',
                                color: color,
                                textSize: 20,
                                isTitle: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      flex: 2,
                      child: TextFormField(
                        controller: _quantityTextController,
                        key: const ValueKey('10'),
                        style: TextStyle(color: color, fontSize: 18),
                        keyboardType: TextInputType.number,
                        maxLines: 1,
                        enabled: true,
                        onChanged: (v) {
                          setState(() {
                            if (v.isEmpty) {
                              _quantityTextController.text = '1';
                            } else {
                              return;
                            }
                          });
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp('[0-9.]'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: _isInCart
                      ? null
                      : () async {
                          final User? user = authInstance.currentUser;
                          if (user == null) {
                            // print('user id is: ${user!.uid}');
                            GlobalMethods.errorDialog(
                              subtitle: 'No user found, Please login first',
                              context: context,
                            );
                            return;
                          }
                          await GlobalMethods.addToCart(
                            productId: productModle.id,
                            quantity: int.parse(_quantityTextController.text),
                            context: context,
                          );
                          await cartProvider.fetchCart();

                          // cartProvider.addProductsToCart(
                          //   productId: productModle.id,
                          //   quantity: int.parse(_quantityTextController.text),
                          // );
                        },
                  child: TextWidget(
                    text: _isInCart ? 'In cart' : 'Add to cart',
                    maxLines: 1,
                    color: color,
                    textSize: 20,
                  ),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      Theme.of(context).cardColor,
                    ),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12.0),
                          bottomRight: Radius.circular(12.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
