import 'package:flutter/material.dart';

class ClanEditScreen extends StatefulWidget {
  const ClanEditScreen({super.key});

  @override
  _ClanEditScreenState createState() => _ClanEditScreenState();
}

class _ClanEditScreenState extends State<ClanEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  void _saveClanDetails() {
    if (_formKey.currentState!.validate()) {
      // Save the clan details
      String name = _nameController.text;
      String description = _descriptionController.text;
      // Store or update the clan details accordingly

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Clan details saved successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Clan Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Clan Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a clan name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveClanDetails,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
