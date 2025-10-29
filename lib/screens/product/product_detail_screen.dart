 

import 'package:amazon_clone/core/app_colors.dart';
import 'package:amazon_clone/screens/cart/cart_screen.dart';
import 'package:amazon_clone/screens/home/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/product_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  final String productId;
  const ProductDetailScreen({required this.productId});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final product =
        productProvider.products.firstWhere((p) => p.id == productId);
    final cart = context.watch<CartProvider>();
    final isInCart = cart.isInCart(product.id);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          product.name,
          style: const TextStyle(color: AppColors.white),
        ),
        iconTheme: const IconThemeData(color: AppColors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: CachedNetworkImage(
                  imageUrl: product.imageUrl,
                  height: 280,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (_, __) =>
                      const Center(child: CircularProgressIndicator()),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              product.name,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
            ),

            const SizedBox(height: 6),

            Text(
              "Category: ${product.category}",
              style: const TextStyle(
                color: AppColors.primaryColor,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "₹${product.price.toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),

            const SizedBox(height: 18),

            Text(
              product.description,
              style: const TextStyle(
                fontSize: 15,
                height: 1.5,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 26),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      if (isInCart) {
                        context.read<BottomNavProvider>().setIndex(2);
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BottomNavScreen()),
                          (route) => false, 
                        );
                      } else {
                        await cart.addItem(product);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Added to cart")),
                        );
                      }
                    },
                    icon: Icon(
                        isInCart
                            ? Icons.shopping_cart
                            : Icons.add_shopping_cart,
                        color: AppColors.white),
                    label: Text(isInCart ? "View to Cart" : "Add to Cart",
                        style: TextStyle(color: AppColors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Expanded(
                //   child: OutlinedButton(
                //     onPressed: () {
                //       // Navigator.push(context, MaterialPageRoute(builder: (_) => CheckoutScreen()));
                //     },
                //     style: OutlinedButton.styleFrom(
                //       side:
                //           BorderSide(color: AppColors.primaryColor, width: 1.5),
                //       padding: const EdgeInsets.symmetric(vertical: 14),
                //       shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(10)),
                //     ),
                //     child: const Text("Buy Now",
                //         style: TextStyle(color: AppColors.primaryColor)),
                //   ),
                // ),
              ],
            ),

            const SizedBox(height: 32),

            // Reviews Title
            // Reviews Title
            Text(
              "Reviews",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context)
                        .primaryColor, 
                  ),
            ),

            const SizedBox(height: 10),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              itemBuilder: (_, i) => ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context)
                      .primaryColor
                      .withOpacity(0.15), 
                  child: Text(
                    "U${i + 1}",
                    style: TextStyle(
                      color:
                          Theme.of(context).primaryColor, 
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  "User ${i + 1}",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor, 
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text("Very good product! Value for money."),
              ),
              separatorBuilder: (_, __) => Divider(
                color: Theme.of(context)
                    .primaryColor
                    .withOpacity(0.2), 
              ),
            ),
          ],
        ),
      ),
    );
  }
}
