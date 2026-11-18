import 'package:flutter/material.dart';

import '../domain/models/contact.dart';
import '../viewmodels/contact_state.dart';
import '../viewmodels/contact_view_model.dart';
import 'contact_form_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key, required this.viewModel});

  final ContactViewModel viewModel;

  Future<void> _confirmDelete(
    BuildContext context,
    ContactViewModel vm,
    Contact contact,
  ) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus kontak?'),
        content: Text('${contact.name} akan dihapus dari daftar.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (ok == true) vm.deleteContact(contact.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kontaku')),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) => switch (viewModel.state) {
          ContactLoading() => const Center(child: CircularProgressIndicator()),
          ContactEmpty() => const Center(
            child: Text(
              'Belum ada kontak.\nTekan tombol + untuk menambah.',
              textAlign: TextAlign.center,
            ),
          ),
          ContactError(:final message) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(message),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: viewModel.loadContacts,
                  child: const Text('Coba lagi'),
                ),
              ],
            ),
          ),
          ContactLoaded(:final contacts) => ListView.separated(
            itemCount: contacts.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final contact = contacts[index];
              return ListTile(
                leading: CircleAvatar(
                  child: Text(contact.name[0].toUpperCase()),
                ),
                title: Text(contact.name),
                subtitle: Text(contact.phone),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      tooltip: 'Edit',
                      icon: const Icon(Icons.edit),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ContactFormView(
                            viewModel: viewModel,
                            contact: contact,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Hapus',
                      icon: const Icon(Icons.delete),
                      onPressed: () =>
                          _confirmDelete(context, viewModel, contact),
                    ),
                  ],
                ),
              );
            },
          ),
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Tambah kontak',
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ContactFormView(viewModel: viewModel),
          ),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
