class Contact {
  final String id;
  final String name;
  final String phone;

  const Contact({required this.id, required this.name, required this.phone});

  Contact copyWith({String? name, String? phone}) {
    return Contact(id: id, name: name ?? this.name, phone: phone ?? this.phone);
  }
}
