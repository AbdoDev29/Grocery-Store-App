import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/wishlist_provider.dart';
import 'package:shop/screens/wishlist/wishlist_widget.dart';
import 'package:shop/services/global_methods.dart';
import 'package:shop/services/utils.dart';
import 'package:shop/widgets/back_widget.dart';
import 'package:shop/widgets/empty_screen.dart';
import 'package:shop/widgets/text_widget.dart';

class WishlistScreen extends StatelessWidget {
  static const routeName = "/WidhlistScreen";
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    // Size size = Utils(context).getScreenSize;
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final wishlistItemList = wishlistProvider.getwishlistItems.values
        .toList()
        .reversed
        .toList();
    return wishlistItemList.isEmpty
        ? const EmptyScreen(
            title: 'Your wishlist is empty',
            subtitle: 'Explore more and shortlist some items',
            buttonText: 'Add a wish',
            imagePath: 'assets/images/wishlist.png',
          )
        : Scaffold(
            appBar: AppBar(
              centerTitle: true,
              leading: const BackWidget(),
              automaticallyImplyLeading: false,
              elevation: 0,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: TextWidget(
                text: 'Wishlist (${wishlistItemList.length})',
                color: color,
                textSize: 22,
                isTitle: true,
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    GlobalMethods.warningDialog(
                      title: 'Empty your wishlist?',
                      subtitle: 'Are you sure?',
                      fct: () async {
                        await wishlistProvider.clearOnlineWishlist();
                        wishlistProvider.clearLocalWishlist();
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
            body: MasonryGridView.count(
              itemCount: wishlistItemList.length,
              crossAxisCount: 2,
              // mainAxisSpacing: 4,
              // crossAxisSpacing: 4,
              itemBuilder: (context, index) {
                return ChangeNotifierProvider.value(
                  value: wishlistItemList[index],
                  child: const WishlistWidget(),
                );
              },
            ),
          );
  }

  Widget _checkOut({required BuildContext ctx}) {
    final Color color = Utils(ctx).color;
    Size size = Utils(ctx).getScreenSize;
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
                onTap: () {},
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
                text: 'Total: \$0.259',
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
}
