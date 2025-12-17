import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shop/inner_screens/product_details.dart';
import 'package:shop/models/orders_model.dart';
import 'package:shop/providers/product_provider.dart';
import 'package:shop/services/global_methods.dart';

import '../../services/utils.dart';
import '../../widgets/text_widget.dart';

class OrdersWidget extends StatefulWidget {
  const OrdersWidget({Key? key}) : super(key: key);

  @override
  State<OrdersWidget> createState() => _OrdersWidgetState();
}

class _OrdersWidgetState extends State<OrdersWidget> {
  late String orderDateToShow;

  @override
  void didChangeDependencies() {
    final ordersModel = Provider.of<OrderModel>(context);
    var orderDate = ordersModel.orderDate.toDate();
    orderDateToShow = '${orderDate.day}/${orderDate.month}/${orderDate.year}';
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final ordersModel = Provider.of<OrderModel>(context);
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final productProvider = Provider.of<ProductProvider>(context);
    final getCurrProduct = productProvider.findProdById(ordersModel.productId);
    return ListTile(
      subtitle: Text(
        'Paid: \$${double.parse(ordersModel.price).toStringAsFixed(2)}',
        style: TextStyle(color: color),
      ),
      onTap: () {
        GlobalMethods.navigateTo(
          ctx: context,
          routeName: ProductDetails.routeName,
        );
      },
      leading: FancyShimmerImage(
        width: size.width * 0.2,
        imageUrl: getCurrProduct.imageUrl,
        boxFit: BoxFit.fill,
      ),
      title: TextWidget(
        text: '${getCurrProduct.title}  x${ordersModel.quantity}',
        color: color,
        textSize: 18,
      ),
      trailing: TextWidget(text: orderDateToShow, color: color, textSize: 18),
    );
  }
}
