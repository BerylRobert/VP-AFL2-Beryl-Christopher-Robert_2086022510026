import '../../domain/models/contact.dart';

abstract class ContactDataSource {
  Future<List<Contact>> readAll();
  Future<void> writeAll(List<Contact> contacts);
}