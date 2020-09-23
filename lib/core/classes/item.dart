class Item {
  String id;
  String code;
  String image;
  String imageUrl;
  String name;
  String description1;
  String description2;
  double price;
  String type;
  String measure_type;
  double measure_amount;
  double measure_unit;
  String saleInfo;
  /* order */
  int order_count;
  double order_total;
  String order_id;

  Item({this.id, this.code, this.image, this.imageUrl, this.name, this.description1, this.description2, this.price, this.type,
          this.measure_type, this.measure_amount, this.measure_unit, this.saleInfo, this.order_count, this.order_total});


  Item.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    code = json['code'] ?? '';
    image = json['image'];
    name = json['name'] ?? '';
    description1 = json['description1'] ?? '';
    description2 = json['description2'] ?? '';
    price = json['price'] != null ? double.tryParse(json['price']) : null;
    type = json['type'];
    measure_type = json['measure_type'];
    measure_amount = json['measure_amount'] != null ? double.tryParse(json['measure_amount']) : null;
    measure_unit = json['measure_unit'] != null ? double.tryParse(json['measure_unit']) : null;
    saleInfo = json['saleInfo'] ?? '';
    order_count = json['order_count'] != null ? int.tryParse(json['order_count']) : null;
    order_total = json['order_total'] != null ? double.tryParse(json['order_total']) : null;
    order_id = json['order_id'] ?? '';
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
    data['saleInfo'] = this.saleInfo;
    data['order_count'] = this.order_count;
    data['order_total'] = this.order_total;
    return data;
  }
}