import 'package:flutter/material.dart';

class WishlishModel with ChangeNotifier {
  final String id, productId;

  WishlishModel({
    required this.id,
    required this.productId,
  });
}
