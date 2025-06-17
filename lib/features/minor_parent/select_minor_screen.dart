import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/minor_parent_provider.dart';
import '../../providers/minors_provider.dart';

class SelectMinorScreen extends ConsumerStatefulWidget {
  const SelectMinorScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SelectMinorScreen> createState() => _SelectMinorScreenState();
}

class _SelectMinorScreenState extends ConsumerState<SelectMinorScreen> {
  String? _selectedMinor;
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final minorsAsync = ref.watch(minorsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Select Minor')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            minorsAsync.when(
              data: (minors) => DropdownButton<String>(
                value: _selectedMinor,
                hint: const Text('Select Minor'),
                onChanged: (v) => setState(() => _selectedMinor = v),
                items: minors
                    .map(
                      (m) => DropdownMenuItem(value: m, child: Text(m)),
                    )
                    .toList(),
              ),
              loading: () => const CircularProgressIndicator(),
              error: (_, __) => const Text('Error loading minors'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Parent Phone'),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _selectedMinor != null && _phoneController.text.isNotEmpty
                  ? () {
                      ref
                          .read(minorParentProvider.notifier)
                          .sendOtp(_selectedMinor!, _phoneController.text);
                      Navigator.pushNamed(context, '/verify-parent');
                    }
                  : null,
              child: const Text('Next'),
            )
          ],
        ),
      ),
    );
  }
}
