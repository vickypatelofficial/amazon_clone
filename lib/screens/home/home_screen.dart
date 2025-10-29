import 'package:amazon_clone/core/app_colors.dart';
import 'package:amazon_clone/providers/cart_provider.dart';
import 'package:amazon_clone/providers/wish_list_provider.dart';
import 'package:amazon_clone/screens/product/product_detail_screen.dart';
import 'package:amazon_clone/screens/product/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final FocusNode searchFocus = FocusNode();
  final TextEditingController searchCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);
    final productProvider = context.watch<ProductProvider>();
    final wishlist = context.watch<WishlistProvider>();
    // ✅ Fetch products only first time widget loads
    // Future.microtask(() {
    //   if (productProvider.products.isEmpty) {
    //     productProvider.fetchProducts();
    //   }
    // });

    return GestureDetector(
      onTap: () =>
          FocusScope.of(context).unfocus(), // tap outside hide keyboard

      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          elevation: 0,
          title: const Text(
            "amazon",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Column(
          children: [
            /// ✅ SEARCH BOX
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: FocusScope(
                onFocusChange: (_) => (context as Element).markNeedsBuild(),
                child: TextField(
                  controller: searchCtrl,
                  focusNode: searchFocus,
                  onChanged: productProvider.search,
                  cursorColor: AppColors.primaryColor,
                  decoration: InputDecoration(
                    hintText: "Search products...",
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    prefixIcon: Icon(
                      Icons.search,
                      color: searchFocus.hasFocus
                          ? AppColors.primaryColor
                          : Colors.grey.shade600,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: Colors.grey.shade400, width: 1.2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: AppColors.primaryColor, width: 2),
                    ),
                  ),
                ),
              ),
            ),

            /// ✅ PRODUCTS GRID
            Expanded(
              child: productProvider.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : productProvider.filteredProducts.isEmpty
                      ? Center(child: Text("No products found"))
                      : Consumer<CartProvider>(
                          builder: (context, cartProvider, _) {
                          return GridView.builder(
                            padding: const EdgeInsets.all(8),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 0.66,
                            ),
                            itemCount: productProvider.filteredProducts.length,
                            itemBuilder: (_, i) {
                              final p = productProvider.filteredProducts[i];
                              return ProductCard(
                                imageUrl: p.imageUrl,
                                productName: p.name,
                                isWishlisted: wishlist.isWishlisted(p.id),
                                onWishlistPressed: () =>
                                    wishlist.toggleWishlist(p),
                                categoryName: p.category,
                                price: "₹ ${p.price.toStringAsFixed(0)}",
                                isCartAdded: cart.isInCart(p.id),
                                onProductPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ProductDetailScreen(
                                                productId: p.id,
                                              )));
                                },
                                onAddToCartPressed: () async {
                                  await cart.addItem(p);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Added to cart")),
                                  );
                                },
                              );
                            },
                          );
                        }),
            ),
          ],
        ),
      ),
    );
  }
}
