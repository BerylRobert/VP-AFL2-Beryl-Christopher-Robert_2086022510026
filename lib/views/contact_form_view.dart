import 'package:flutter/material.dart';

import '../domain/models/contact.dart';
import '../viewmodels/contact_view_model.dart';

class ContactFormView extends StatefulWidget {
  final Contact? contact;

  const ContactFormView({super.key, required this.viewModel, this.contact});
  final ContactViewModel viewModel;

  @override
  State<ContactFormView> createState() => _ContactFormViewState();
}

class _ContactFormViewState extends State<ContactFormView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;

  bool get _isEdit => widget.contact != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.contact?.name ?? '');
    _phoneController = TextEditingController(text: widget.contact?.phone ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final vm = widget.viewModel;
    if (_isEdit) {
      await vm.updateContact(
        widget.contact!,
        _nameController.text,
        _phoneController.text,
      );
    } else {
      await vm.addContact(_nameController.text, _phoneController.text);
    }
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final vm = widget.viewModel;

    return Scaffold(
      appBar: AppBar(title: Text(_isEdit ? 'Edit Kontak' : 'Tambah Kontak')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap',
                  border: OutlineInputBorder(),
                ),
                validator: vm.validateName,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Nomor HP',
                  border: OutlineInputBorder(),
                ),
                validator: vm.validatePhone,
                onFieldSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _submit,
                  child: const Text('Selesai'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
