import 'package:amazon_clone/core/app_colors.dart';
import 'package:amazon_clone/screens/cart/cart_screen.dart';
import 'package:amazon_clone/screens/categories/categories_screen.dart';
import 'package:amazon_clone/screens/profile/profile_screen.dart'; 
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'package:provider/provider.dart'; 

class BottomNavScreen extends StatelessWidget {
    BottomNavScreen({super.key});

  final screens =   [
    HomeScreen(),
    CategoriesScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final nav = context.watch<BottomNavProvider>();

    return Scaffold(
      body: screens[nav.index],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.white,
        currentIndex: nav.index,
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (i) => nav.setIndex(i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: "Category"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}


class BottomNavProvider extends ChangeNotifier {
  int _index = 0;
  int get index => _index;

  void setIndex(int newIndex) {
    _index = newIndex;
    notifyListeners();
  }
}
