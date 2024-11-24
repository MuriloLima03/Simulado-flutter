class Transport {
  final int id;
  final String companyName;

  Transport({required this.id, required this.companyName});

  factory Transport.fromJson(Map<String, dynamic> json) {
    return Transport(
      id: json['id'],
      companyName: json['companyName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'companyName': companyName};
  }
}
