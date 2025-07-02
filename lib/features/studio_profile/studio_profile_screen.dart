import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appoint/models/studio_profile.dart';
import 'package:appoint/services/studio_profile_service.dart';

class StudioProfileScreen extends ConsumerStatefulWidget {
  final String studioId;
  const StudioProfileScreen({super.key, required this.studioId});

  @override
  ConsumerState<StudioProfileScreen> createState() =>
      _StudioProfileScreenState();
}

class _StudioProfileScreenState extends ConsumerState<StudioProfileScreen> {
  StudioProfile? _profile;
  bool _loading = true;
  final _formKey = GlobalKey<FormState>();
  late final StudioProfileService _service;

  @override
  void initState() {
    super.initState();
    _service = StudioProfileService();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _loading = true);
    final profile = await _service.fetchProfile(widget.studioId);
    setState(() {
      _profile = profile;
      _loading = false;
    });
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      if (_profile != null) {
        await _service.saveProfile(_profile!);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile saved!')),
          );
        }
      }
    }
  }

  @override
  Widget build(final BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (_profile == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Studio Profile')),
        body: const Center(child: Text('Profile not found.')),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Studio Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _profile!.name,
                decoration: const InputDecoration(labelText: 'Studio Name'),
                onSaved: (final v) =>
                    _profile = _profile!.copyWith(name: v ?? ''),
                validator: (final v) =>
                    v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _profile!.description,
                decoration: const InputDecoration(labelText: 'Description'),
                onSaved: (final v) =>
                    _profile = _profile!.copyWith(description: v),
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _profile!.address,
                decoration: const InputDecoration(labelText: 'Address'),
                onSaved: (final v) => _profile = _profile!.copyWith(address: v),
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _profile!.phone,
                decoration: const InputDecoration(labelText: 'Phone'),
                onSaved: (final v) => _profile = _profile!.copyWith(phone: v),
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _profile!.email,
                decoration: const InputDecoration(labelText: 'Email'),
                onSaved: (final v) => _profile = _profile!.copyWith(email: v),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Admin Free Access'),
                value: _profile!.isAdminFreeAccess ?? false,
                onChanged: (final v) => setState(
                    () => _profile = _profile!.copyWith(isAdminFreeAccess: v)),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveProfile,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
