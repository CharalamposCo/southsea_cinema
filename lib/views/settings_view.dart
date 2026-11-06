import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import '../widgets/nav_drawer.dart';
import '../widgets/primary_button.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _addressController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _patronController = TextEditingController();

  final SharedPreferencesAsync _preferences = SharedPreferencesAsync();

  bool _receiveNews = false;
  bool _isLoading = true;

  String _savedAddress = '';
  String _savedEmail = '';
  String _savedPatron = '';
  bool _savedReceiveNews = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final String address =
        await _preferences.getString('customer_address') ?? '';

    final String email = await _preferences.getString('customer_email') ?? '';

    final String patron = await _preferences.getString('customer_patron') ?? '';

    final bool receiveNews =
        await _preferences.getBool('receive_news') ?? false;

    if (!mounted) return;

    setState(() {
      _savedAddress = address;
      _savedEmail = email;
      _savedPatron = patron;
      _savedReceiveNews = receiveNews;

      _addressController.text = address;
      _emailController.text = email;
      _patronController.text = patron;
      _receiveNews = receiveNews;

      _isLoading = false;
    });
  }

  Future<void> _saveSettings() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final String address = _addressController.text.trim();
    final String email = _emailController.text.trim();
    final String patron = _patronController.text.trim();

    await _preferences.setString('customer_address', address);
    await _preferences.setString('customer_email', email);
    await _preferences.setString('customer_patron', patron);
    await _preferences.setBool('receive_news', _receiveNews);

    if (!mounted) return;

    setState(() {
      _savedAddress = address;
      _savedEmail = email;
      _savedPatron = patron;
      _savedReceiveNews = _receiveNews;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Settings saved successfully'),
      ),
    );
  }

  void _cancelSettings() {
    setState(() {
      _addressController.text = _savedAddress;
      _emailController.text = _savedEmail;
      _patronController.text = _savedPatron;
      _receiveNews = _savedReceiveNews;
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
        borderSide: BorderSide(
          color: cinemaBrand,
          width: 2,
        ),
      ),
      contentPadding: const EdgeInsets.all(20),
    );
  }

  @override
  void dispose() {
    _addressController.dispose();
    _emailController.dispose();
    _patronController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle),
      ),
      drawer: const NavDrawer(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
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
                            !RegExp(r'^[^@]+@[^@]+\.[^@]+$')
                                .hasMatch(value.trim())) {
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
