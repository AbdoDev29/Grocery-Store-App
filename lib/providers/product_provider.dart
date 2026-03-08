import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../models/products_model.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ProductProvider with ChangeNotifier {
  List<ProductModel> _productsList = [];
  bool _isFetched = false;
  List<ProductModel> get getProducts {
    return _productsList;
  }

  List<ProductModel> get getOnSaleProducts {
    return _productsList.where((element) => element.isOnSale).toList();
  }

  Future<void> fetchProducts() async {
    if (_isFetched) return;
    try {
      // 👈 correct try-catch structure
      final QuerySnapshot productSnapshot = await FirebaseFirestore.instance
          .collection('products')
          .get();

      _productsList = [];

      for (var element in productSnapshot.docs) {
        // 👈 use for loop not forEach
        _productsList.insert(
          0,
          ProductModel(
            id: element.get('id'),
            title: element.get('title'),
            imageUrl: element.get('imageUrl'),
            productCategoryName: element.get('productCategoryName'),
            price: double.parse(element.get('price')),
            salePrice: element.get('salePrice'),
            isOnSale: element.get('isOnSale'),
            isPiece: element.get('isPiece'),
          ),
        );
      }

      _isFetched = true; // 👈 outside the loop
      notifyListeners(); // 👈 outside the loop
    } catch (error) {
      rethrow;
    }
  }

  void clearCache() {
    _isFetched = false;
    _productsList = [];
    notifyListeners();
  }

  ProductModel findProdById(String productId) {
    return _productsList.firstWhere((element) => element.id == productId);
  }

  List<ProductModel> findByCategory(String categoryName) {
    List<ProductModel> _categoryList = _productsList
        .where(
          (element) => element.productCategoryName.toLowerCase().contains(
            categoryName.toLowerCase(),
          ),
        )
        .toList();
    return _categoryList;
  }

  List<ProductModel> searchQuery(String searchText) {
    List<ProductModel> _searchList = _productsList
        .where(
          (element) => element.title.toLowerCase().contains(
            searchText.toLowerCase(),
          ),
        )
        .toList();
    return _searchList;
  }
}
