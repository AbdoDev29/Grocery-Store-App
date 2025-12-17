import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shop/consts/firebase_consts.dart';
import 'package:shop/providers/cart_provider.dart';
import 'package:shop/providers/orders_provider.dart';
import 'package:shop/providers/product_provider.dart';
import 'package:shop/screens/cart/cart_widget.dart';
import 'package:shop/widgets/empty_screen.dart';
import 'package:shop/services/global_methods.dart';
import 'package:shop/services/utils.dart';
import 'package:shop/widgets/text_widget.dart';
import 'package:uuid/uuid.dart';

class CardScreen extends StatelessWidget {
  const CardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItemList = cartProvider.getCartItems.values
        .toList()
        .reversed
        .toList();

    // Size size = Utils(context).getScreenSize;
    return cartItemList.isEmpty
        ? const EmptyScreen(
            title: 'Your cart is empty',
            subtitle: 'Add something and make me happy :)',
            buttonText: 'shop now',
            imagePath: 'assets/images/cart.png',
          )
        : Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              elevation: 0,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: TextWidget(
                text: 'Cart (${cartItemList.length})',
                color: color,
                textSize: 22,
                isTitle: true,
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    GlobalMethods.warningDialog(
                      title: 'Empty your cart?',
                      subtitle: 'Are you sure?',
                      fct: () async {
                        await cartProvider.clearOnlineCart();
                        cartProvider.clearLocalCart();
                      },
                      context: context,
                    );
                  },
                  icon: Icon(
                    IconlyBroken.delete,
                    color: color,
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                _checkOut(ctx: context),
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItemList.length,
                    itemBuilder: (ctx, index) {
                      return ChangeNotifierProvider.value(
                        value: cartItemList[index],
                        child: CartWidget(
                          q: cartItemList[index].quantity,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
  }

  Widget _checkOut({required BuildContext ctx}) {
    final Color color = Utils(ctx).color;
    Size size = Utils(ctx).getScreenSize;
    final cartProvider = Provider.of<CartProvider>(ctx);
    final productProvider = Provider.of<ProductProvider>(ctx);
    final ordersProvider = Provider.of<OrdersProvider>(ctx);

    double total = 0.0;
    cartProvider.getCartItems.forEach((key, value) {
      final getCurrProduct = productProvider.findProdById(value.productId);
      total +=
          (getCurrProduct.isOnSale
              ? getCurrProduct.salePrice
              : getCurrProduct.price) *
          value.quantity;
    });

    return SizedBox(
      width: double.infinity,
      height: size.height * 0.1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Material(
              color: Colors.green,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () async {
                  User? user = authInstance.currentUser;

                  final productProvider = Provider.of<ProductProvider>(
                    ctx,
                    listen: false,
                  );
                  try {
                    await initPayment(
                      amount: total * 100,
                      email: user!.email ?? '',
                      context: ctx,
                    );
                  } catch (error) {
                    print('an error occured $error');
                    return;
                  }
                  cartProvider.getCartItems.forEach((key, value) async {
                    final getCurrProduct = productProvider.findProdById(
                      value.productId,
                    );
                    try {
                      final orderId = const Uuid().v4();
                      await FirebaseFirestore.instance
                          .collection('orders')
                          .doc(orderId)
                          .set({
                            'orderId': orderId,
                            'userId': user.uid,
                            'productId': value.productId,
                            'price':
                                (getCurrProduct.isOnSale
                                    ? getCurrProduct.salePrice
                                    : getCurrProduct.price) *
                                value.quantity,
                            'totalPrice': total,
                            'quantity': value.quantity,
                            'imageUrl': getCurrProduct.imageUrl,
                            'userName': user.displayName,
                            'orderDate': Timestamp.now(),
                          });
                      await cartProvider.clearOnlineCart();
                      cartProvider.clearLocalCart();
                      ordersProvider.fetchOrders();
                      await Fluttertoast.showToast(
                        msg: "Your order has been placed",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                      );
                    } catch (error) {
                      GlobalMethods.errorDialog(
                        subtitle: error.toString(),
                        context: ctx,
                      );
                    } finally {}
                  });
                },

                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextWidget(
                    text: 'Order Now',
                    color: Colors.white,
                    textSize: 20,
                  ),
                ),
              ),
            ),
            const Spacer(),
            FittedBox(
              child: TextWidget(
                text: 'Total: \$${total.toStringAsFixed(2)}',
                color: color,
                textSize: 18,
                isTitle: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> initPayment({
    required String email,
    required double amount,
    required BuildContext context,
  }) async {
    try {
      // 1. Create a payment intent on the server
      final response = await http.post(
        Uri.parse('https://stripepaymentintenrequest-vaasibj2yq-uc.a.run.app'),
        body: {
          'email': email,
          'amount': amount.toString(),
        },
      );
      final jsonRespone = jsonDecode(response.body);
      if (jsonRespone['success'] == false) {
        GlobalMethods.errorDialog(
          subtitle: jsonRespone['error'],
          context: context,
        );
        throw jsonRespone['error'];
      }
      // log(jsonRespone());
      // 2. Initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: jsonRespone['paymentIntent'],
          merchantDisplayName: 'Shop',
          customerId: jsonRespone['customer'],
          customerEphemeralKeySecret: jsonRespone['ephemeralkey'],

          // testEnv: true,
          // mercha
        ),
      );
      await Stripe.instance.presentPaymentSheet();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Payment is successful')));
    } catch (error) {
      if (error is StripeException) {
        print('The erroe is: $error');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
          SnackBar(
            content: Text('An error occured ${error.error.localizedMessage}'),
          ),
        );
      } else {
        print('The erroe is: $error');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
          SnackBar(
            content: Text('An error occured $error'),
          ),
        );
      }
      throw '$error';
    }
  }
}
