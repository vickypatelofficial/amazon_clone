import 'package:amazon_clone/core/app_colors.dart';
import 'package:amazon_clone/screens/categories/widgets/category_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import '../../services/product_service.dart';
import 'filtered_list_screen.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<String> categories = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadCats();
  }

  Future<void> _loadCats() async {
    final ps = ProductService();
    final data = await ps.fetchCategories();
    setState(() {
      categories = data;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final prod = Provider.of<ProductProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.white, 
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0.5,
        title: Text(
          "Categories",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
        ),
        centerTitle: false,
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadCats,
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                children: [
                  const SizedBox(height: 14),

                  GridView.builder(
                    itemCount: categories.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, 
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.92, 
                    ),
                    itemBuilder: (_, i) {
                      final category = categories[i];
                      final list = prod.byCategory(category);
                      final image = list.isNotEmpty ? list.first.imageUrl : "";

                      return CategoryCard(
                        categoryText: category,
                        imageUrl: image,
                        onPressed: () {
                          final filtered = prod.byCategory(category);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FilteredListScreen(
                                category: category,
                                items: filtered,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }
}
