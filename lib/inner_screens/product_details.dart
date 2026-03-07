import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:shop/consts/firebase_consts.dart';
import 'package:shop/providers/cart_provider.dart';
import 'package:shop/providers/product_provider.dart';
import 'package:shop/providers/viewed_prod_provider.dart';
import 'package:shop/providers/wishlist_provider.dart';
import 'package:shop/services/global_methods.dart';
import 'package:shop/services/utils.dart';
import 'package:shop/widgets/heart_btn.dart';
import 'package:shop/widgets/text_widget.dart';

class ProductDetails extends StatefulWidget {
  static const routeName = '/ProductDetails';
  const ProductDetails({super.key});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final _quantityTextController = TextEditingController(text: '1');

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _quantityTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    final Color color = Utils(context).color;
    final theme = Utils(context).getTheme;
    final productProviders = Provider.of<ProductProvider>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);

    final productId = ModalRoute.of(context)!.settings.arguments as String;

    final getCurrProduct = productProviders.findProdById(productId);
    final cartProvider = Provider.of<CartProvider>(context);
    final viewedProdProvider = Provider.of<ViewedProdProvider>(context);
    bool? _isInCart = cartProvider.getCartItems.containsKey(getCurrProduct.id);

    double usedPrice = getCurrProduct.isOnSale
        ? getCurrProduct.salePrice
        : getCurrProduct.price;

    bool? _isInWishlist = wishlistProvider.getwishlistItems.containsKey(
      getCurrProduct.id,
    );

    double totalPrice = usedPrice * int.parse(_quantityTextController.text);
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        viewedProdProvider.addProductToHistory(productId: productId);
      },
      // onWillPop: () async {
      //   viewedProdProvider.addProductToHistory(productId: productId);
      //   return true;
      // },
      child: Scaffold(
        appBar: AppBar(
          leading: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () =>
                Navigator.canPop(context) ? Navigator.pop(context) : null,
            child: Icon(
              IconlyLight.arrowLeft2,
              color: color,
              size: 24,
            ),
          ),
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        body: Column(
          children: [
            Flexible(
              flex: 2,
              child: FancyShimmerImage(
                imageUrl: getCurrProduct.imageUrl,
                boxFit: BoxFit.scaleDown,
                width: size.width,
              ),
            ),
            Flexible(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 20,
                        left: 30,
                        right: 30,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: TextWidget(
                              text: getCurrProduct.title,
                              color: color,
                              textSize: 25,
                              isTitle: true,
                            ),
                          ),
                          HeartBTN(
                            productId: getCurrProduct.id,
                            isInWishlist: _isInWishlist,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 20,
                        left: 30,
                        right: 30,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextWidget(
                            text: '\$${usedPrice.toStringAsFixed(2)}/',
                            color: color,
                            textSize: 22,
                            isTitle: true,
                          ),
                          TextWidget(
                            text: getCurrProduct.isPiece ? 'Piece' : '/kg',
                            color: color,
                            textSize: 12,
                            isTitle: false,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Visibility(
                            visible: getCurrProduct.isOnSale ? true : false,
                            child: Text(
                              '\$${getCurrProduct.price.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 15,
                                color: color,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(63, 200, 101, 1),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: TextWidget(
                              text: 'Free delivery',
                              color: Colors.white,
                              textSize: 20,
                              isTitle: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        _quantityController(
                          fct: () {
                            if (_quantityTextController.text == '1') {
                              return;
                            } else {
                              setState(() {
                                _quantityTextController.text =
                                    (int.parse(
                                              _quantityTextController.text,
                                            ) -
                                            1)
                                        .toString();
                              });
                            }
                          },
                          color: const Color(0xffF57E2A),
                          icon: CupertinoIcons.minus,
                          isPlus: false,
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        Flexible(
                          flex: 1,
                          child: TextField(
                            style: TextStyle(
                              color: color,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                            controller: _quantityTextController,
                            key: const ValueKey('quantity'),
                            keyboardType: TextInputType.number,
                            maxLines: 1,
                            readOnly: true,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,

                              focusedBorder: InputBorder.none,
                              isDense: false,
                              contentPadding: EdgeInsets.zero,
                            ),
                            textAlign: TextAlign.center,
                            cursorColor: Colors.green,
                            enabled: true,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp('[0-9]'),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                if (value.isEmpty) {
                                  _quantityTextController.text = '1';
                                } else {}
                              });
                            },
                          ),
                        ),
                        // const SizedBox(
                        //   width: 2,
                        // ),
                        _quantityController(
                          fct: () {
                            setState(() {
                              _quantityTextController.text =
                                  (int.parse(
                                            _quantityTextController.text,
                                          ) +
                                          1)
                                      .toString();
                            });
                            // if (_quantityTextController.text == '1') {
                            //   return;
                            // } else {

                            // }
                          },
                          color: const Color(0xffF57E2A),
                          icon: CupertinoIcons.plus,
                          isPlus: true,
                        ),
                        const Spacer(),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 30,
                      ),
                      decoration: BoxDecoration(
                        color: theme ? const Color(0xFF1a1f3c) : Colors.white,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextWidget(
                                  text: 'Total',
                                  color: const Color(0xffD85454),
                                  textSize: 20,
                                  isTitle: true,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                FittedBox(
                                  child: Row(
                                    children: [
                                      TextWidget(
                                        text:
                                            '\$${totalPrice.toStringAsFixed(2)}',
                                        color: color,
                                        textSize: 20,
                                        isTitle: true,
                                      ),
                                      TextWidget(
                                        text:
                                            '${_quantityTextController.text}Kg',

                                        color: color,
                                        textSize: 16,
                                        isTitle: false,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Flexible(
                            child: Material(
                              color: const Color(0xffF48A3B),
                              borderRadius: BorderRadius.circular(10),
                              child: InkWell(
                                onTap: _isInCart
                                    ? null
                                    : () async {
                                        final User? user =
                                            authInstance.currentUser;
                                        if (user == null) {
                                          GlobalMethods.errorDialog(
                                            subtitle:
                                                'No user found, Please login first',
                                            context: context,
                                          );
                                          return;
                                        }
                                        await GlobalMethods.addToCart(
                                          productId: getCurrProduct.id,
                                          quantity: int.parse(
                                            _quantityTextController.text,
                                          ),
                                          context: context,
                                        );
                                        await cartProvider.fetchCart();
                                        // cartProvider.addProductsToCart(
                                        //   productId: getCurrProduct.id,
                                        //   quantity: int.parse(
                                        //     _quantityTextController.text,
                                        //   ),
                                        // );
                                      },
                                borderRadius: BorderRadius.circular(10),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 38,
                                  ),
                                  child: TextWidget(
                                    text: _isInCart ? 'In cart' : 'Add to cart',
                                    color: Colors.white,
                                    textSize: 18,
                                    isTitle: true,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget quantityControl({
    required Function fct,
    required IconData icon,
    required Color color,
  }) {
    return Flexible(
      flex: 2,
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: color,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            fct();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              icon,
              color: Colors.white,
              size: 25,
            ),
          ),
        ),
      ),
    );
  }

  Widget _quantityController({
    required Function fct,
    required IconData icon,
    required Color color,
    required bool isPlus, // 👈 add this
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: isPlus
          ? Material(
              color: color,
              borderRadius: BorderRadius.circular(24),
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: () => fct(),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            )
          : Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: color,
                  width: 1.5,
                ),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: () => fct(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    icon,
                    color: color,
                    size: 20,
                  ),
                ),
              ),
            ),
    );
  }
}
