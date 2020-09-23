class DeliveryTime {
  String type;				// Regular, Custom
  String customDay;
  String beginTime;
  String endTime;
  bool isPastTime;
  bool isSelected;
  int orderCountOnThatTime;

  DeliveryTime({this.type, this.customDay, this.beginTime, this.endTime, this.isPastTime, this.isSelected});

  DeliveryTime.fromJson(Map<String, dynamic> json) {
    type = json['type'] ?? '';
    customDay = json['customDay'] ?? '';
    beginTime = json['beginTime'] ?? '';
    endTime = json['endTime'] ?? '';
    isPastTime = false;		// by default every time is in future at first, and calculate it in logic
    isSelected = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['customDay'] = this.customDay.toString() ?? '';
    data['beginTime'] = this.beginTime.toString();
    data['endTime'] = this.endTime.toString();
    return data;
  }

  DeliveryTime.clone(DeliveryTime source) :
        this.type = source.type,
        this.customDay = source.customDay,
        this.beginTime = source.beginTime,
        this.endTime = source.endTime;
}