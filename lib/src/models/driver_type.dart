class DriverType {
  int? id;
  String? name;
  double? range;
  int? lastAccess;

  DriverType(
      {this.id,
        this.name,
        this.range,
        this.lastAccess,
        });

  DriverType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    range = json['range']!=null?json['range'].toDouble() : 0.0;
    lastAccess = json['last_access'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['range'] = this.range;
    data['last_access'] = this.lastAccess;
    return data;
  }
}
