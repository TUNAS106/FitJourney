import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import 'dart:ui';

class EditProfilePage extends StatefulWidget {
  final String name;
  final String email;
  final String gender;
  final int age;
  final String? phoneNumber; // thêm
  final String? bio;         // thêm
  final String? location;    // thêm

  const EditProfilePage({
    Key? key,
    required this.name,
    required this.email,
    required this.gender,
    required this.age,
    this.phoneNumber,
    this.bio,
    this.location,           // thêm
  }) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _genderController;
  late TextEditingController _ageController;
  late TextEditingController _phoneController;
  late TextEditingController _bioController;
  late TextEditingController _locationController;  // thêm

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _emailController = TextEditingController(text: widget.email);
    _genderController = TextEditingController(text: widget.gender);
    _ageController = TextEditingController(text: widget.age.toString());
    _phoneController = TextEditingController(text: widget.phoneNumber ?? '');
    _bioController = TextEditingController(text: widget.bio ?? '');
    _locationController = TextEditingController(text: widget.location ?? '');  // thêm
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _genderController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    _locationController.dispose();  // thêm
    super.dispose();
  }

  Future<void> _saveProfile() async {
    try {
      await context.read<AuthBloc>().updateUserInfoDirect(
        name: _nameController.text,
        email: widget.email,
        gender: _genderController.text,
        age: int.tryParse(_ageController.text) ?? widget.age,
        phoneNumber: _phoneController.text,
        bio: _bioController.text,
        location: _locationController.text,
      );
      Navigator.pop(context, true);
    } catch (e) {
      // Hiện lỗi cho người dùng hoặc log lỗi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi lưu thông tin: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final String backgroundImageUrl = 'assets/design/gym1.jpg'; // thay đường dẫn ảnh của bạn

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 4,
        centerTitle: true, // Căn giữa title
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            letterSpacing: 1.1,
          ),
        ),
        //iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Background Image
          Image.asset(
            backgroundImageUrl,
            fit: BoxFit.cover,
          ),

          // 2. Blur layer + màu phủ đen nhẹ
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),

          // 3. Nội dung chính
          SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 8,
              color: Colors.white.withOpacity(0.95),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Name')),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      enabled: false,
                    ),
                    const SizedBox(height: 12),
                    TextField(controller: _genderController, decoration: const InputDecoration(labelText: 'Gender')),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _ageController,
                      decoration: const InputDecoration(labelText: 'Age'),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _phoneController,
                      decoration: const InputDecoration(labelText: 'Phone Number'),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _bioController,
                      decoration: const InputDecoration(labelText: 'Bio'),
                      maxLines: 100,
                      minLines: 1,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _locationController,
                      decoration: const InputDecoration(labelText: 'Location'),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _saveProfile,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 5,
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Save', style: TextStyle(fontSize: 18)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
