import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhoneNumberInput extends StatelessWidget {
  final TextEditingController phoneController;
  final void Function(String) onPhoneNumberSubmitted;

  PhoneNumberInput({
    required this.phoneController,
    required this.onPhoneNumberSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: phoneController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: 'Enter your phone number (E.164 format)',
            hintText: '+819012345678',
          ),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\+?[0-9]*$')),
          ],
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            String phoneNumber = phoneController.text.trim();
            if (_isValidPhoneNumber(phoneNumber)) {
              // Valid phone number, trigger callback
              onPhoneNumberSubmitted(phoneNumber);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Invalid phone number format")),
              );
            }
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }

  // E.164形式かを確認する関数
  bool _isValidPhoneNumber(String phoneNumber) {
    final regex = RegExp(r'^\+[1-9]\d{1,14}$');
    return regex.hasMatch(phoneNumber);
  }
}
