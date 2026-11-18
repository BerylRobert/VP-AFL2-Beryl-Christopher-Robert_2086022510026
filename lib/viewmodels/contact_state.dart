import 'package:equatable/equatable.dart';

import '../domain/models/contact.dart';

sealed class ContactState extends Equatable {
  const ContactState();

  @override
  List<Object?> get props => [];
}

class ContactLoading extends ContactState {
  const ContactLoading();
}

class ContactEmpty extends ContactState {
  const ContactEmpty();
}

class ContactLoaded extends ContactState {
  final List<Contact> contacts;
  const ContactLoaded(this.contacts);

  @override
  List<Object?> get props => [contacts];
}

class ContactError extends ContactState {
  final String message;
  const ContactError(this.message);

  @override
  List<Object?> get props => [message];
}
