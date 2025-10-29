import 'package:amazon_clone/core/app_colors.dart';
import 'package:amazon_clone/screens/auth/login_screen.dart';
import 'package:amazon_clone/screens/home/bottom_nav_bar.dart';
import 'package:amazon_clone/screens/profile/update_profile_screen.dart';
import 'package:amazon_clone/screens/wish_list/wish_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primaryColor,
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double screenWidth = constraints.maxWidth;
          double profileImageSize = screenWidth * 0.18;
          double textSizeTitle = screenWidth < 380 ? 16 : 18;
          double textSizeSub = screenWidth < 380 ? 12 : 14;

          return ListView(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05,
              vertical: 24,
            ),
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: profileImageSize / 2,
                    backgroundColor: AppColors.primaryColor.withOpacity(0.2),
                    backgroundImage:
                        auth.photo.isNotEmpty ? NetworkImage(auth.photo) : null,
                    child: auth.photo.isEmpty
                        ? Icon(Icons.person,
                            size: profileImageSize * 0.6, color: Colors.white)
                        : null,
                  ),
                  SizedBox(width: screenWidth * 0.04),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        auth.name.isNotEmpty ? auth.name : "Your Name",
                        style: TextStyle(
                          fontSize: textSizeTitle,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: screenWidth * 0.01),
                      Text(
                        auth.phone.isNotEmpty ? auth.phone : "No Number",
                        style: TextStyle(
                          fontSize: textSizeSub,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: screenWidth * 0.08),

              _menu(
                icon: Icons.person_outline,
                title: "Edit Profile",
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const UpdateProfileScreen()),
                ),
              ),
              _menu(
                icon: Icons.favorite_border,
                title: "Wishlist",
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const WishlistScreen()),
                ),
              ),
              _menu(
                icon: Icons.shopping_bag_outlined,
                title: "My Orders",
                onTap: () {},
              ),
              _menu(
                icon: Icons.language,
                title: "Language",
                onTap: () {},
              ),

              Divider(height: screenWidth * 0.12),

              _menu(
                icon: Icons.logout,
                title: "Logout",
                color: Colors.red,
                onTap: () {
                  auth.logout();
                  context.read<BottomNavProvider>().setIndex(0);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                    (route) => false,
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _menu({
    required IconData icon,
    required String title,
    Color? color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      minLeadingWidth: 0,
      leading: Icon(icon, color: color ?? AppColors.primaryColor, size: 22),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
}
