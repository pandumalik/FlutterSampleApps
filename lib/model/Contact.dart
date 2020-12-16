class Contact {
  int id;
  String name, phone, email;

  Contact(this.id, this.name, this.phone, this.email);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
    };
    return map;
  }

  Contact.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    phone = map['price'];
    email = map['email'];
  }
}
