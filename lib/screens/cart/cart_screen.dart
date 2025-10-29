import 'package:amazon_clone/core/app_colors.dart';
import 'package:amazon_clone/providers/cart_provider.dart';
import 'package:amazon_clone/providers/product_provider.dart';
import 'package:amazon_clone/screens/cart/widgets/custom_cart_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final catalog = context.watch<ProductProvider>().productMap; // pid → ProductModel

    final isEmpty = cart.items.isEmpty;
    final width = MediaQuery.of(context).size.width;

    double subtotal = cart.totalPrice(catalog);
    double delivery = isEmpty ? 0 : 99;
    double discount = isEmpty ? 0 : 200;
    double total = subtotal + delivery - discount;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        automaticallyImplyLeading: false,
        title: const Text("Cart", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),

      body: isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),
                  const Text("Your cart is empty!", style: TextStyle(fontSize: 18)),
                ],
              ),
            )
          : Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 100),
                  child: Column(
                    children: [
                      ...cart.items.entries.map((entry) {
                        final productId = entry.key;
                        final qty = entry.value;
                        final product = catalog[productId];

                        if (product == null) return const SizedBox();

                        return CartItem(
                          image: product.imageUrl,
                          title: product.name,
                          category: product.category,
                          price: (product.price * qty).toStringAsFixed(0),
                          quantity: qty.toString(),
                          onIncrease: () => cart.updateQuantity(productId, qty + 1),
                          onDecrease: () => cart.updateQuantity(productId, qty - 1),
                          onRemove: () => cart.removeItem(productId),
                        );
                      }).toList(),

                      const SizedBox(height: 16),
 
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [
                            BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))
                          ],
                        ),
                        child: Column(
                          children: [
                            summaryRow("Sub Total", "Rs.${subtotal.toStringAsFixed(0)}"),
                            summaryRow("Delivery Charges", "Rs.$delivery"),
                            summaryRow("Discount", "- Rs.$discount", color: Colors.red),
                            const Divider(),
                            summaryRow(
                              "Total Price",
                              "Rs.${total.toStringAsFixed(0)}",
                              valueStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),

                // Checkout Button
                // Positioned(
                //   bottom: 0,
                //   left: 0,
                //   right: 0,
                //   child: CheckoutButton(
                //     total: total.toStringAsFixed(0),
                //     text: "Continue",
                //     onPressed: () {
                //       // TODO -> Checkout Screen
                //     },
                //   ),
                // ),
              ],
            ),
    );
  }

  Widget summaryRow(String label, String value, {Color? color, TextStyle? valueStyle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: color ?? Colors.black87)),
          Text(value, style: valueStyle ?? TextStyle(color: color ?? Colors.black87)),
        ],
      ),
    );
  }
}
