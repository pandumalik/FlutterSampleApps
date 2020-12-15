class Grocery {
  int id, price, quantity;
  String name;

  Grocery(this.id, this.name, this.price, this.quantity);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'name': name,
      'price': price,
      'quantity': quantity,
    };
    return map;
  }

  Grocery.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    price = map['price'];
    quantity = map['quantity'];
  }
}
