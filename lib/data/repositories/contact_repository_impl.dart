import '../../domain/models/contact.dart';
import '../../domain/repositories/contact_repository.dart';
import '../services/contact_data_source.dart';

class ContactRepositoryImpl implements ContactRepository {
  ContactRepositoryImpl(this._source);

  final ContactDataSource _source;

  @override
  Future<List<Contact>> getContacts() => _source.readAll();

  @override
  Future<void> addContact(Contact contact) async {
    final contacts = await _source.readAll();
    await _source.writeAll([...contacts, contact]);
  }

  @override
  Future<void> updateContact(Contact contact) async {
    final contacts = await _source.readAll();
    await _source.writeAll([
      for (final c in contacts) c.id == contact.id ? contact : c,
    ]);
  }

  @override
  Future<void> deleteContact(String id) async {
    final contacts = await _source.readAll();
    await _source.writeAll([
      for (final c in contacts)
        if (c.id != id) c,
    ]);
  }
}