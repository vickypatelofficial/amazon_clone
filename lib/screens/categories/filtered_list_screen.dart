import 'package:amazon_clone/core/app_colors.dart';
import 'package:amazon_clone/providers/cart_provider.dart';
import 'package:amazon_clone/providers/wish_list_provider.dart';
import 'package:amazon_clone/screens/product/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:amazon_clone/screens/product/widgets/product_card.dart';
import 'package:provider/provider.dart';
import '../../models/product_model.dart';

class FilteredListScreen extends StatelessWidget {
  final String category;
  final List<ProductModel> items;

  const FilteredListScreen({
    super.key,
    required this.category,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final wishlist = context.watch<WishlistProvider>();
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.white),
        title: Text(category,style: TextStyle(color: AppColors.white),),

        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: items.isEmpty
          ? const Center(child: Text("No Products in this category"))
          : Consumer<CartProvider>(
              builder: (context, cartProvider, _) {
                return GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.66,
                  ),
                  itemCount: items.length,
                  itemBuilder: (_, i) {
                    final p = items[i];

                    return ProductCard(
                      imageUrl: p.imageUrl,
                      productName: p.name,
                      categoryName: p.category,
                      price: "₹ ${p.price.toStringAsFixed(0)}",
                      isCartAdded: cartProvider.isInCart(p.id), // ✅ Same logic
                      isWishlisted: wishlist.isWishlisted(p.id),
                      onWishlistPressed: () => wishlist.toggleWishlist(p),
                      onProductPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailScreen(
                              productId: p.id,
                            ),
                          ),
                        );
                      },

                      onAddToCartPressed: () async {
                        await cartProvider.addItem(p);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Added to cart")),
                        );
                      },
                    );
                  },
                );
              },
            ),
    );
  }
}
