class Location {
  final int id;
  final String name;
  final String? address;

  Location({required this.id, required this.name, this.address});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'] as int,
      name: json['name'] as String,
      address: json['address'] as String?,
    );
  }
}
