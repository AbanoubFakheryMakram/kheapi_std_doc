class Doctor {
  String name;
  String username;
  String password;
  String ssn;
  String email;
  String phone;
  String image;
  String id;
  List<String> subjects;

  Doctor({
    String name,
    String username,
    String password,
    String ssn,
    String email,
    String phone,
    String id,
    String image,
    List<String> subjects,
  }) {
    this.name = name;
    this.username = username;
    this.password = password;
    this.ssn = ssn;
    this.email = email;
    this.phone = phone;
    this.id = id;
    this.image = image;
    this.subjects = subjects;
  }

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'username': this.username,
      'password': this.password,
      'ssn': this.ssn,
      'email': this.email,
      'phone': this.phone,
      'image': this.image,
      'id': this.id,
      'subjects': this.subjects
    };
  }

  factory Doctor.fromMap(Map map) {
    return Doctor(
      name: map['name'],
      password: map['password'],
      username: map['username'],
      ssn: map['ssn'],
      email: map['email'],
      phone: map['phone'],
      image: map['image'],
      id: map['id'],
      subjects: List.from(map['subjects']),
    );
  }
}
