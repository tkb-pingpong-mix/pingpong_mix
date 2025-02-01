import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pingpong_mix/utils/image_upload.dart';
import 'package:pingpong_mix/viewmodels/user_viewmodel.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _displayNameController;
  late final TextEditingController _regionController;
  late final TextEditingController _racketController;
  late final TextEditingController _forehandRubberController;
  late final TextEditingController _backhandRubberController;
  late final TextEditingController _shoesController;
  File? _selectedImage;

  String? _skillLevel;
  String? _playStyle;

  @override
  void initState() {
    super.initState();
    final user = ref.read(userViewModelProvider).value;
    _displayNameController =
        TextEditingController(text: user?.displayName ?? '');
    _regionController = TextEditingController(text: user?.region ?? '');
    _racketController = TextEditingController(text: user?.racket ?? '');
    _forehandRubberController =
        TextEditingController(text: user?.forehandRubber ?? '');
    _backhandRubberController =
        TextEditingController(text: user?.backhandRubber ?? '');
    _shoesController = TextEditingController(text: user?.shoes ?? '');
    _skillLevel = user?.skillLevel;
    _playStyle = user?.playStyle;
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: userState.when(
        data: (user) {
          if (user == null) {
            return const Center(child: Text('No user data available'));
          }

          return SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: _selectedImage != null
                            ? FileImage(_selectedImage!)
                            : (user.profilePicture.isNotEmpty
                                    ? NetworkImage(user.profilePicture)
                                    : const AssetImage(
                                        'assets/images/profile_placeholder.png'))
                                as ImageProvider,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ..._buildFormFields(),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      textStyle: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () async {
                      String? imageUrl;
                      if (_selectedImage != null) {
                        imageUrl =
                            await ImageUploader.uploadImage(_selectedImage!);
                      }
                      ref.read(userViewModelProvider.notifier).updateUser(
                            user.copyWith(
                              displayName: _displayNameController.text,
                              profilePicture: imageUrl ?? user.profilePicture,
                              skillLevel: _skillLevel ?? user.skillLevel,
                              region: _regionController.text,
                              racket: _racketController.text,
                              forehandRubber: _forehandRubberController.text,
                              backhandRubber: _backhandRubberController.text,
                              shoes: _shoesController.text,
                            ),
                          );
                      Navigator.pop(context);
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }

  List<Widget> _buildFormFields() {
    return [
      _buildTextField(_displayNameController, 'Display Name', Icons.person),
      _buildDropdownField(
          'Skill Level',
          _skillLevel,
          ['Beginner', 'Intermediate', 'Advanced'],
          (value) => setState(() => _skillLevel = value)),
      _buildTextField(_regionController, 'Region', Icons.location_on),
      _buildTextField(_racketController, 'Racket', Icons.sports_tennis),
      _buildTextField(
          _forehandRubberController, 'Forehand Rubber', Icons.sports_tennis),
      _buildTextField(
          _backhandRubberController, 'Backhand Rubber', Icons.sports_tennis),
      _buildTextField(_shoesController, 'Shoes', Icons.directions_run),
    ];
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField(String label, String? value, List<String> items,
      Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: DropdownButtonFormField<String>(
        value: value,
        items: items
            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
            .toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      ),
    );
  }
}
