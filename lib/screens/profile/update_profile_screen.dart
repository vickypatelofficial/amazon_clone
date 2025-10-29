import 'package:amazon_clone/core/app_colors.dart';
import 'package:amazon_clone/widgets/custom_lable_textfiled.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  late TextEditingController nameCtrl;
  late TextEditingController phoneCtrl;

  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthProvider>();
    nameCtrl = TextEditingController(text: auth.name);
    phoneCtrl = TextEditingController(text: auth.phone);
  }

  InputDecoration customInput(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: AppColors.primaryColor.withOpacity(0.7)),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
            color: AppColors.primaryColor.withOpacity(0.6), width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.white),
        backgroundColor: AppColors.primaryColor,
        title: const Text(
          "Profile",
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
 
            // Stack(
            //   alignment: Alignment.bottomRight,
            //   children: [
            //     CircleAvatar(
            //       radius: 55,
            //       backgroundImage: auth.pickedImage != null
            //           ? FileImage(auth.pickedImage!)
            //           : (auth.photo.isNotEmpty ? NetworkImage(auth.photo) : null)
            //               as ImageProvider?,
            //       child: (auth.photo.isEmpty && auth.pickedImage == null)
            //           ? const Icon(Icons.person, size: 55)
            //           : null,
            //     ),
            //     GestureDetector(
            //       onTap: _pickImageOption,
            //       child: Container(
            //         padding: const EdgeInsets.all(6),
            //         decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            //         child: const Icon(Icons.camera_alt, size: 20),
            //       ),
            //     ),
            //   ],
            // ),

            LabeledTextField(
              label: "Name",
              icon: Icons.person,
              controller: nameCtrl,
            ),
            const SizedBox(height: 15),

            LabeledTextField(
              label: "Email",
              icon: Icons.email,
              readOnly: true,
              hint: auth.user?.email ?? "",
            ),
            const SizedBox(height: 15),

            LabeledTextField(
              label: "Phone Number",
              icon: Icons.phone,
              controller: phoneCtrl,
              keyboardType: TextInputType.phone,
              maxLength: 10,
            ),

            const SizedBox(height: 30),

            const SizedBox(height: 30),
 
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor),
                onPressed: auth.isLoading
                    ? null
                    : () async {
                        auth.name = nameCtrl.text.trim();
                        auth.phone = phoneCtrl.text.trim();
                        await auth.saveProfile();

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Profile Updated Successfully")),
                        );
                      },
                child: auth.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Save Changes",
                        style: TextStyle(color: AppColors.white),
                      ),
              ),
            ),
            const SizedBox(height: 15),

            /// Logout Button
            // SizedBox(
            //   width: double.infinity,
            //   height: 48,
            //   child: ElevatedButton(
            //     style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            //     onPressed: () async => await auth.logout(),
            //     child: const Text("Sign Out"),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
