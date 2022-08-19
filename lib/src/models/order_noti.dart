class OrderNotification {
  Restaurant? restaurant;
  int? createdAt;
  int? id;
  List<String>? drivers;

  OrderNotification({this.restaurant, this.id, this.drivers});

  OrderNotification.fromJson(Map<String, dynamic> json) {
    restaurant = json['restaurant'] != null
        ? new Restaurant.fromJson(json['restaurant'])
        : null;
   createdAt = json['created_at'] != null ? json['created_at'] : 0;
    id = json['id'];
    drivers = json['drivers'] != null ? List.from(json['drivers']) : [];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.restaurant != null) {
      data['restaurant'] = this.restaurant!.toJson();
    }
   // data['created_at'] = this.createdAt;
    data['id'] = this.id;
    data['drivers'] = this.drivers;
    // if (this.drivers != null) {
    //   data['drivers'] = this.drivers.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class Restaurant {
  String? name;
  int? id;

  Restaurant({this.name, this.id});

  Restaurant.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['id'] = this.id;
    return data;
  }
}

class Drivers {
  double? distance;
  int? id;

  Drivers({this.distance, this.id});

  Drivers.fromJson(Map<String, dynamic> json) {
    distance = json['distance'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['distance'] = this.distance;
    data['id'] = this.id;
    return data;
  }
}
