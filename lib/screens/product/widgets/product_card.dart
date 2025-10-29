import 'package:amazon_clone/core/app_colors.dart';
import 'package:amazon_clone/widgets/custom_network_image.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String productName;
  final String categoryName;
  final String price;
  final VoidCallback onAddToCartPressed;
  final VoidCallback onProductPressed;
  final bool? isCartAdded;
  final VoidCallback onWishlistPressed;
  final bool isWishlisted;

  const ProductCard({
    Key? key,
    required this.imageUrl,
    required this.productName,
    required this.categoryName,
    required this.price,
    required this.onAddToCartPressed,
    required this.onProductPressed,
    this.isCartAdded,
    required this.onWishlistPressed,
    required this.isWishlisted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double imageHeight = screenWidth * 0.35;
    final double borderRadius = screenWidth * 0.025;
    final double buttonSize = screenWidth * 0.09;
    final double padding = screenWidth * 0.025;

    return InkWell(
      onTap: onProductPressed,
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: borderRadius * 0.8,
              offset: Offset(0, borderRadius * 0.3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: imageHeight,
              width: double.infinity,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(borderRadius),
                    ),
                    child: CustomNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
 
                  Positioned(
                    top: padding,
                    right: padding,
                    child: InkWell(
                      onTap: onWishlistPressed,
                      child: Container(
                        padding: EdgeInsets.all(screenWidth * 0.02),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isWishlisted ? Icons.favorite : Icons.favorite_border,
                          color: AppColors.primaryColor,
                          size: screenWidth * 0.055,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  padding,
                  padding * 0.8,
                  padding,
                  padding * 0.5,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        productName,
                        style: TextStyle(
                          color: AppColors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: screenWidth * 0.033,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      categoryName,
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: screenWidth * 0.028,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(padding, 0, padding, padding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    price,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.038,
                    ),
                  ),
                  InkWell(
                    onTap: onAddToCartPressed,
                    child: Container(
                      height: buttonSize,
                      width: buttonSize,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(borderRadius * 0.8),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        (isCartAdded ?? false)
                            ? Icons.shopping_cart
                            : Icons.add,
                        color: Colors.white,
                        size: buttonSize * 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
