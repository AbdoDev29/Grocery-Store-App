import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/dark_theme_provider.dart';
import 'package:shop/providers/cart_provider.dart';
import 'package:shop/screens/cart/cart_screen.dart';
import 'package:shop/screens/categories.dart';
import 'package:shop/screens/home_screen.dart';
import 'package:shop/screens/user.dart';
import 'package:badges/badges.dart' as badges;
import 'package:shop/widgets/text_widget.dart';

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({super.key});

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  int _selectedIndex = 0;
  final List<Map<String, dynamic>> _pages = [
    {'page': const HomeScreen(), 'title': 'Home Screen'},
    {'page': CategoriesScreen(), 'title': 'Category Screen'},
    {'page': const CardScreen(), 'title': 'Card Screen'},
    {'page': const UserScreen(), 'title': 'User Screen'},
  ];

  void _selectedPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;
    bool _isDark = themeState.getDarkTheme;
    return Scaffold(
      body: _pages[_selectedIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectedPage,
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: _isDark ? Theme.of(context).cardColor : Colors.white,

        showSelectedLabels: false,
        showUnselectedLabels: false,
        unselectedItemColor: _isDark ? Colors.white10 : Colors.black12,
        selectedItemColor: _isDark ? Colors.lightBlue.shade200 : Colors.black87,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              color: color,
              _selectedIndex == 0 ? IconlyBold.home : IconlyLight.home,
            ),
            label: "Home",
          ),

          BottomNavigationBarItem(
            icon: Icon(
              color: color,
              _selectedIndex == 1 ? IconlyBold.category : IconlyLight.category,
            ),
            label: "Categories",
          ),
          BottomNavigationBarItem(
            icon: Consumer<CartProvider>(
              builder: (context, myCart, child) {
                return badges.Badge(
                  badgeAnimation: const badges.BadgeAnimation.slide(),
                  badgeStyle: badges.BadgeStyle(
                    shape: badges.BadgeShape.circle,
                    badgeColor: Colors.blue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  position: badges.BadgePosition.topEnd(top: -7, end: -7),
                  badgeContent: FittedBox(
                    child: TextWidget(
                      text: myCart.getCartItems.length.toString(),
                      color: Colors.white,
                      textSize: 15,
                    ),
                  ),
                  child: Icon(
                    color: color,
                    _selectedIndex == 2 ? IconlyBold.buy : IconlyLight.buy,
                  ),
                );
              },
            ),
            label: "Card",
          ),

          BottomNavigationBarItem(
            icon: Icon(
              color: color,
              _selectedIndex == 3 ? IconlyBold.user2 : IconlyLight.user2,
            ),
            label: "User",
          ),
        ],
      ),
    );
  }
}
