import 'package:flutter/foundation.dart';

import '../domain/models/contact.dart';
import '../domain/repositories/contact_repository.dart';
import 'contact_state.dart';

class ContactViewModel extends ChangeNotifier {
  final ContactRepository _repository;
  ContactViewModel(this._repository);

  ContactState _state = const ContactLoading();
  ContactState get state => _state;

  bool _disposed = false;

  Future<void> loadContacts() async {
    _emit(const ContactLoading());
    try {
      final contacts = await _repository.getContacts();
      _emit(contacts.isEmpty ? const ContactEmpty() : ContactLoaded(contacts));
    } catch (_) {
      _emit(const ContactError('Gagal memuat kontak. Silakan coba lagi.'));
    }
  }

  Future<void> addContact(String name, String phone) {
    return _perform(
      () => _repository.addContact(
        Contact(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          name: name.trim(),
          phone: phone.trim(),
        ),
      ),
      'Gagal menambahkan kontak. Silakan coba lagi.',
    );
  }

  Future<void> updateContact(Contact contact, String name, String phone) {
    return _perform(
      () => _repository.updateContact(
        contact.copyWith(name: name.trim(), phone: phone.trim()),
      ),
      'Gagal mengubah kontak. Silakan coba lagi.',
    );
  }

  Future<void> deleteContact(String id) {
    return _perform(
      () => _repository.deleteContact(id),
      'Gagal menghapus kontak. Silakan coba lagi.',
    );
  }

  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nama lengkap wajib diisi';
    }
    return null;
  }

  String? validatePhone(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Nomor HP wajib diisi';
    if (!RegExp(r'^[0-9+\-\s]{8,15}$').hasMatch(text)) {
      return 'Nomor HP tidak valid (8-15 digit)';
    }
    return null;
  }

  Future<void> _perform(
    Future<void> Function() action,
    String errorMessage,
  ) async {
    try {
      await action();
      await loadContacts();
    } catch (_) {
      _emit(ContactError(errorMessage));
    }
  }

  void _emit(ContactState newState) {
    if (_disposed) return;
    _state = newState;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
