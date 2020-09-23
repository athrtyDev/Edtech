class ItemOrder {
  String id;
  String code;
  String image;
  String name;
  String description1;
  String description2;
  double price;
  String type;
  String measure_type;
  double measure_amount;
  double measure_unit;
  /* order */
  String item_id;
  double order_count;
  double order_total;


  ItemOrder({this.id, this.code, this.image, this.name, this.description1, this.description2, this.price, this.type,
    this.measure_type, this.measure_amount, this.measure_unit});

  ItemOrder.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    image = json['image'];
    name = json['name'];
    description1 = json['description1'];
    description2 = json['description2'];
    price = json['price'] != null ? double.tryParse(json['price']) : null;
    type = json['type'];
    measure_type = json['measure_type'];
    measure_amount = json['measure_amount'] != null ? double.tryParse(json['measure_amount']) : null;
    measure_unit = json['measure_unit'] != null ? double.tryParse(json['measure_unit']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['image'] = this.image;
    data['name'] = this.name;
    data['description1'] = this.description1;
    data['description2'] = this.description2;
    data['price'] = this.price.toString();
    data['type'] = this.type;
    data['measure_type'] = this.measure_type;
    data['measure_amount'] = this.measure_amount.toString();
    data['measure_unit'] = this.measure_unit.toString();
    return data;
  }
}