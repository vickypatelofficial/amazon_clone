import 'package:amazon_clone/core/app_colors.dart';
import 'package:amazon_clone/widgets/custom_network_image.dart';
import 'package:flutter/material.dart';

class CartItem extends StatelessWidget {
  final String title;
  final String category;
  final String price;
  final String quantity;
  final String image;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onRemove;

  const CartItem({
    super.key,
    required this.title,
    required this.category,
    required this.price,
    required this.quantity,
    required this.image,
    required this.onIncrease,
    required this.onDecrease,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final imgSize = width * 0.27;
    final cardHeight = imgSize + 24;

    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CustomNetworkImage(
                  imageUrl: image,
                  width: imgSize,
                  height: cardHeight,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: width * 0.03),
              Expanded(
                child: SizedBox(
                  height: cardHeight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: width * 0.038),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: width * 0.01),
                      Text(
                        category,
                        style: TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: width * 0.034),
                      ),
                      SizedBox(height: width * 0.01),
                      Text(
                        'Rs. $price',
                        style: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.04),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          _iconButton(Icons.remove, onDecrease,
                              background: Colors.grey.shade300),
                          SizedBox(width: width * 0.02),
                          Container(
                            width: width * 0.12,
                            padding: EdgeInsets.symmetric(
                                horizontal: width * 0.03, vertical: 6),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              quantity,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: width * 0.04),
                            ),
                          ),
                          SizedBox(width: width * 0.02),
                          _iconButton(Icons.add, onIncrease,
                              background: AppColors.primaryColor,
                              iconColor: Colors.white),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        Positioned(
          right: 6,
          bottom: 16,
          child: InkWell(
            onTap: onRemove,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.black.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.delete, color: Colors.black, size: 22),
            ),
          ),
        ),
      ],
    );
  }

  Widget _iconButton(IconData icon, VoidCallback onTap,
      {Color? background, Color? iconColor}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: background ?? Colors.grey.shade200,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 18, color: iconColor ?? Colors.black87),
      ),
    );
  }
}
