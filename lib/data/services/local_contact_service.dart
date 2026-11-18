import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/models/contact.dart';
import 'contact_data_source.dart';

class LocalContactService implements ContactDataSource {
  static const _key = 'contacts';

  @override
  Future<List<Contact>> readAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list.map((e) => _fromMap(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<void> writeAll(List<Contact> contacts) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(contacts.map(_toMap).toList()));
  }

  Map<String, dynamic> _toMap(Contact c) =>
      {'id': c.id, 'name': c.name, 'phone': c.phone};

  Contact _fromMap(Map<String, dynamic> m) => Contact(
        id: m['id'] as String,
        name: m['name'] as String,
        phone: m['phone'] as String,
      );
}