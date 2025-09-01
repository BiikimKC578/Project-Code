
class Student {
  final int? id;
  final String khmerName;
  final String latinName;
  final String gender;
  final DateTime dob;
  final String? address;
  final String? tel;

  Student({
    this.id,
    required this.khmerName,
    required this.latinName,
    required this.gender,
    required this.dob,
    this.address,
    this.tel,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      khmerName: json['khmer_name'],
      latinName: json['latin_name'],
      gender: json['gender'],
      dob: DateTime.parse(json['dob']),
      address: json['address'],
      tel: json['tel'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'khmer_name': khmerName,
      'latin_name': latinName,
      'gender': gender,
      'dob': dob.toIso8601String(),
      'address': address,
      'tel': tel,
    };
  }
}
