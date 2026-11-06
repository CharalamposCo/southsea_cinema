import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/widgets/nav_drawer.dart';
import 'package:southsea_cinema/widgets/primary_button.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _addressController = TextEditingController(
    text: 'Buckingham Building,\nLion Terrace,\nPortsmouth\nPO1 3HE',
  );

  final TextEditingController _emailController =
      TextEditingController(text: 'alex@example.com');

  final TextEditingController _patronController =
      TextEditingController(text: '1234');

  bool _receiveNews = true;

  @override
  void dispose() {
    _addressController.dispose();
    _emailController.dispose();
    _patronController.dispose();
    super.dispose();
  }

  void _saveSettings() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Settings saved successfully'),
        ),
      );
    }
  }

  void _cancelSettings() {
    setState(() {
      _addressController.text =
          'Buckingham Building,\nLion Terrace,\nPortsmouth\nPO1 3HE';
      _emailController.text = 'alex@example.com';
      _patronController.text = '1234';
      _receiveNews = true;
    });
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: cinemaSurface,
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: Colors.white24),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: Colors.white24),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: cinemaBrand, width: 2),
      ),
      contentPadding: const EdgeInsets.all(20),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle),
      ),
      drawer: const NavDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'My Settings',
                style: TextStyle(
                  color: cinemaFontWhite,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 40),

              // Address
              TextFormField(
                controller: _addressController,
                maxLines: 4,
                decoration: _inputDecoration('Address').copyWith(
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      _addressController.clear();
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 32),

              // Email address
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: _inputDecoration('Email Address'),
                validator: (value) {
                  if (value == null ||
                      !RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 32),

              // Patron number
              TextFormField(
                controller: _patronController,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration('Patron Number'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your patron number';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 32),

              // Preferences
              const Text(
                'Preferences',
                style: TextStyle(
                  color: cinemaFontWhite,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      'Receive news by email',
                      style: TextStyle(
                        color: cinemaFontWhite,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Switch(
                    value: _receiveNews,
                    activeThumbColor: cinemaBrand,
                    activeTrackColor: cinemaBrand.withValues(alpha: 0.5),
                    onChanged: (value) {
                      setState(() {
                        _receiveNews = value;
                      });
                    },
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Cancel and Save buttons
              Wrap(
                spacing: 16,
                runSpacing: 12,
                children: [
                  ElevatedButton(
                    onPressed: _cancelSettings,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cinemaSurface,
                      foregroundColor: cinemaFontWhite,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 14,
                      ),
                    ),
                    child: const Text('CANCEL'),
                  ),
                  PrimaryButton(
                    label: 'SAVE SETTINGS',
                    onPressed: _saveSettings,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
