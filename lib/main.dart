import 'dart:convert';
// import 'dart:nativewrappers/_internal/vm/lib/math_patch.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:shop/fetch_screen.dart';
import 'package:shop/inner_screens/cat_screen.dart';
import 'package:shop/inner_screens/feeds_screen.dart';
import 'package:shop/inner_screens/on_sale_screen.dart';
import 'package:shop/inner_screens/product_details.dart';
import 'package:shop/providers/dark_theme_provider.dart';
import 'package:shop/providers/cart_provider.dart';
import 'package:shop/providers/orders_provider.dart';
import 'package:shop/providers/product_provider.dart';
import 'package:shop/providers/viewed_prod_provider.dart';
import 'package:shop/providers/wishlist_provider.dart';
import 'package:shop/screens/auth/forget_password_screen.dart';
import 'package:shop/screens/auth/login_screen.dart';
import 'package:shop/screens/auth/register_screen.dart';
import 'package:provider/provider.dart';
import 'package:shop/screens/btm_bar.dart';
import 'package:shop/screens/orders/orders_screen.dart';
import 'package:shop/screens/viewed_recently/viewed_recently_screen.dart';
import 'package:shop/screens/wishlist/wishlist_screen.dart';
import 'package:shop/stripe_payment/test_screen.dart';
import 'consts/theme_data.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';

Future<void> main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = "PUBLISH_HASH_KEY";
  Stripe.instance.applySettings();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.setDarkTheme = await themeChangeProvider.darkThemePrefs
        .getTheme();
  }

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  final Future<FirebaseApp> _firebaseInitialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _firebaseInitialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: Text('An error occured'),
              ),
            ),
          );
        }
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) {
                return themeChangeProvider;
              },
            ),
            ChangeNotifierProvider(
              create: (_) => ProductProvider(),
            ),
            ChangeNotifierProvider(
              create: (_) => CartProvider(),
            ),
            ChangeNotifierProvider(
              create: (_) => WishlistProvider(),
            ),
            ChangeNotifierProvider(
              create: (_) => ViewedProdProvider(),
            ),
            ChangeNotifierProvider(
              create: (_) => OrdersProvider(),
            ),
          ],
          child: Consumer<DarkThemeProvider>(
            builder: (context, themeProvider, child) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Flutter PaymentDemo',
                theme: Styles.themeData(themeProvider.getDarkTheme, context),
                home: const FetchScreen(),
                routes: {
                  OnSaleScreen.routeName: (ctx) => const OnSaleScreen(),
                  FeedsScreen.routeName: (ctx) => const FeedsScreen(),
                  ProductDetails.routeName: (ctx) => const ProductDetails(),
                  WishlistScreen.routeName: (ctx) => const WishlistScreen(),
                  OrdersScreen.routeName: (ctx) => const OrdersScreen(),
                  ViewedRecentlyScreen.routeName: (ctx) =>
                      const ViewedRecentlyScreen(),
                  RegisterScreen.routeName: (ctx) => const RegisterScreen(),
                  LoginScreen.routeName: (ctx) => const LoginScreen(),
                  ForgetPasswordScreen.routeName: (ctx) =>
                      const ForgetPasswordScreen(),
                  CategoryScreen.routeName: (ctx) => const CategoryScreen(),
                },
              );
            },
          ),
        );
      },
    );
  }
}

// class PaymentDemo extends StatelessWidget {
//   const PaymentDemo({
//     super.key,
//   });
//   Future<void> initPayment({
//     required String email,
//     required double amount,
//     required BuildContext context,
//   }) async {
//     try {
//       // 1. Create a payment intent on the server
//       final response = await http.post(
//         Uri.parse('https://stripepaymentintenrequest-vaasibj2yq-uc.a.run.app'),
//         body: {
//           'email': email,
//           'amount': amount.toString(),
//         },
//       );
//       final jsonRespone = jsonDecode(response.body);
//       // log(jsonRespone());
//       // 2. Initialize the payment sheet
//       await Stripe.instance.initPaymentSheet(
//         paymentSheetParameters: SetupPaymentSheetParameters(
//           paymentIntentClientSecret: jsonRespone['paymentIntent'],
//           merchantDisplayName: 'Shop',
//           customerId: jsonRespone['customer'],
//           customerEphemeralKeySecret: jsonRespone['ephemeralkey'],

//           // testEnv: true,
//           // mercha
//         ),
//       );
//       await Stripe.instance.presentPaymentSheet();
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text('Payment is successful')));
//     } catch (error) {
//       if (error is StripeException) {
//         print('The erroe is: $error');
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(
//           SnackBar(
//             content: Text('An error occured ${error.error.localizedMessage}'),
//           ),
//         );
//       } else {
//         print('The erroe is: $error');
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text('An error occured $error')));
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () async {
//             await initPayment(
//               email: 'email@test.com',
//               amount: 150.0,
//               context: context,
//             );
//           },
//           child: const Text('Pay 50\$'),
//         ),
//       ),
//     );
//   }
// }
