import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shop/inner_screens/product_details.dart';
import 'package:shop/models/cart_model.dart';
import 'package:shop/providers/cart_provider.dart';
import 'package:shop/providers/product_provider.dart';
import 'package:shop/providers/wishlist_provider.dart';
import 'package:shop/services/global_methods.dart';
import 'package:shop/widgets/heart_btn.dart';
import 'package:shop/widgets/text_widget.dart';
import '../../services/utils.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CartWidget extends StatefulWidget {
  const CartWidget({Key? key, required this.q}) : super(key: key);

  final int q;
  @override
  State<CartWidget> createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  final _quantityTextController = TextEditingController();

  get productProviders => null;

  @override
  void initState() {
    _quantityTextController.text = widget.q.toString();
    super.initState();
  }

  @override
  void dispose() {
    _quantityTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    final theme = Utils(context).getTheme;

    Size size = Utils(context).getScreenSize;
    final productProvider = Provider.of<ProductProvider>(context);
    final cartModel = Provider.of<CartModel>(context);
    final getCurrProduct = productProvider.findProdById(cartModel.productId);

    double usedPrice = getCurrProduct.isOnSale
        ? getCurrProduct.salePrice
        : getCurrProduct.price;

    final wishlistProvider = Provider.of<WishlistProvider>(context);

    bool? _isInWishlist = wishlistProvider.getwishlistItems.containsKey(
      getCurrProduct.id,
    );

    final cartProvider = Provider.of<CartProvider>(context);
    return Slidable(
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (context) async {
              final confirm = await GlobalMethods.warningDialog(
                context: context,
                title: 'Remove Item',
                subtitle:
                    'Are you sure you want to remove the item from the cart?',
                fct: () async {
                  await cartProvider.removeOneItem(
                    cartId: cartModel.id,
                    productId: cartModel.productId,
                    quantity: cartModel.quantity,
                  );
                },
              );
            },
            backgroundColor: const Color(0xffD85454),
            foregroundColor: Colors.white,
            icon: Icons.delete_outline,

            label: 'Delete',
            borderRadius: BorderRadius.circular(12),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            ProductDetails.routeName,
            arguments: cartModel.productId,
          );
        },
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        height: size.width * 0.20,
                        width: size.width * 0.20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: FancyShimmerImage(
                          imageUrl: getCurrProduct.imageUrl,
                          boxFit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWidget(
                            text: getCurrProduct.title,
                            color: color,
                            textSize: 20,
                            isTitle: true,
                          ),
                          const SizedBox(
                            height: 16.0,
                          ),
                          TextWidget(
                            text:
                                '\$${(usedPrice * int.parse(_quantityTextController.text)).toStringAsFixed(2)}',
                            color: color,
                            textSize: 18,
                            maxLines: 1,
                            isTitle: true,
                          ),
                        ],
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: SizedBox(
                          width: size.width * 0.12,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Column(
                              children: [
                                _quantityController(
                                  fct: () {
                                    if (_quantityTextController.text == '1') {
                                      return;
                                    } else {
                                      cartProvider.reduceQuantityByOne(
                                        cartModel.productId,
                                      );
                                      setState(() {
                                        _quantityTextController.text =
                                            (int.parse(
                                                      _quantityTextController
                                                          .text,
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
                                SizedBox(
                                  height: 40,
                                  width: 12,
                                  child: TextField(
                                    controller: _quantityTextController,
                                    keyboardType: TextInputType.number,
                                    readOnly: true,
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: color,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      enabledBorder: InputBorder.none,

                                      focusedBorder: InputBorder.none,
                                      isDense: false,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp('[0-9]'),
                                      ),
                                    ],
                                    onChanged: (v) {
                                      setState(() {
                                        if (v.isEmpty) {
                                          _quantityTextController.text = '1';
                                        } else {
                                          return;
                                        }
                                      });
                                    },
                                  ),
                                ),
                                _quantityController(
                                  fct: () {
                                    cartProvider.increaseQuantityByOne(
                                      cartModel.productId,
                                    );
                                    setState(() {
                                      _quantityTextController.text =
                                          (int.parse(
                                                    _quantityTextController
                                                        .text,
                                                  ) +
                                                  1)
                                              .toString();
                                    });
                                  },
                                  color: const Color(0xffF57E2A),
                                  icon: CupertinoIcons.plus,
                                  isPlus: true,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                    ],
                  ),
                ),
              ),
            ),
          ],
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
