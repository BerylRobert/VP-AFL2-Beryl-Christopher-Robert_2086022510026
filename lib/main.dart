import 'package:flutter/material.dart';

import 'data/repositories/contact_repository_impl.dart';
import 'data/services/contact_data_source.dart';
import 'data/services/local_contact_service.dart';
import 'domain/repositories/contact_repository.dart';
import 'viewmodels/contact_view_model.dart';
import 'views/home_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final ContactDataSource source = LocalContactService();
  final ContactRepository repository = ContactRepositoryImpl(source);
  final viewModel = ContactViewModel(repository)..loadContacts();

  runApp(KontakuApp(viewModel: viewModel));
}

class KontakuApp extends StatefulWidget {
  const KontakuApp({super.key, required this.viewModel});

  final ContactViewModel viewModel;

  @override
  State<KontakuApp> createState() => _KontakuAppState();
}

class _KontakuAppState extends State<KontakuApp> {
  @override
  void dispose() {
    widget.viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kontaku',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
      home: HomeView(viewModel: widget.viewModel),
    );
  }
}