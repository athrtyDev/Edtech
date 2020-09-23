import 'package:education/core/classes/delivery_time.dart';
import 'package:education/core/classes/item.dart';
import 'package:education/core/classes/user.dart';

class Order {
  User user;
  List<Item> listItem;
  DeliveryTime time;
  String selectedDay;
  double totalCost;

  Order ({this.user, this.listItem, this.selectedDay, this.time, this.totalCost});



Order.fromJson(Map<String, dynamic> json, String type) {
    selectedDay = json['order_day'] ?? '';
    time = new DeliveryTime();
    time.beginTime = json['order_beginTime'] ?? '';
    time.endTime = json['order_endTime'] ?? '';
  }

  /*Order.fromJson(Map<String, dynamic> json) {
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
    order_count = json['order_count'] != null ? int.tryParse(json['order_count']) : null;
    order_total = json['order_total'] != null ? double.tryParse(json['order_total']) : null;
  }*/
}