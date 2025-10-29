import 'package:amazon_clone/core/app_colors.dart';
import 'package:amazon_clone/providers/wish_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import '../../providers/product_provider.dart';
import '../product/widgets/product_card.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wishlist = context.watch<WishlistProvider>();
    final catalog = context.watch<ProductProvider>().productMap;

    final products = wishlist.wishlist.map((id) => catalog[id]).whereType().toList();

    return Scaffold( 
       appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.white),
        title: Text('Wishlist',style: TextStyle(color: AppColors.white),),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      backgroundColor: AppColors.white,
      body: products.isEmpty
          ? const Center(child: Text("No items in wishlist"))
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.66,
              ),
              itemCount: products.length,
              itemBuilder: (_, i) {
                final p = products[i];
                return ProductCard(
                  imageUrl: p.imageUrl,
                  productName: p.name,
                  categoryName: p.category,
                  price: "₹ ${p.price.toStringAsFixed(0)}",
                  isWishlisted: true,
                  isCartAdded: false,
                  onWishlistPressed: () => wishlist.toggleWishlist(p),
                  onAddToCartPressed: () {},
                  onProductPressed: () {},
                );
              },
            ),
    );
  }
}
