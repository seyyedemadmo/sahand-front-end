class DeviceModel {
  int? _id;
  String? _name;
  String? _code;
  String? _chipIp;
  String? _geom;
  String? _deviceType;
  int? _group;

  DeviceModel(
      {int? id,
      String? name,
      String? code,
      String? chipIp,
      String? geom,
      String? deviceType,
      int? group}) {
    if (id != null) {
      this._id = id;
    }
    if (name != null) {
      this._name = name;
    }
    if (code != null) {
      this._code = code;
    }
    if (chipIp != null) {
      this._chipIp = chipIp;
    }
    if (geom != null) {
      this._geom = geom;
    }
    if (deviceType != null) {
      this._deviceType = deviceType;
    }
    if (group != null) {
      this._group = group;
    }
  }

  int? get id => _id;
  set id(int? id) => _id = id;
  String? get name => _name;
  set name(String? name) => _name = name;
  String? get code => _code;
  set code(String? code) => _code = code;
  String? get chipIp => _chipIp;
  set chipIp(String? chipIp) => _chipIp = chipIp;
  String? get geom => _geom;
  set geom(String? geom) => _geom = geom;
  String? get deviceType => _deviceType;
  set deviceType(String? deviceType) => _deviceType = deviceType;
  int? get group => _group;
  set group(int? group) => _group = group;

  DeviceModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _code = json['code'];
    _chipIp = json['chip_ip'];
    _geom = json['geom'];
    _deviceType = json['device_type'];
    _group = json['group'];
  }
  static List<DeviceModel> fromJsomArray(List<dynamic> array){
    List<DeviceModel> device_list = [];
    for (var i in array){
      device_list.add(
        DeviceModel.fromJson(i)
      );
    }
    return device_list;
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['code'] = this._code;
    data['chip_ip'] = this._chipIp;
    data['geom'] = this._geom;
    data['device_type'] = this._deviceType;
    data['group'] = this._group;
    return data;
  }
  static List<String> get_names(List<DeviceModel> input) {
    List<String> names = [];
    for (var i in input){
      names.add(i.name ?? "");
    }
    return names;
  }

  static List<String> get_full_name(List<DeviceModel> input) {
    List<String> names = [];
    for (var i in input){
      names.add((i.name ?? "") + " (" + (i.chipIp??"") + ")") ;
    }
    return names;
  }

  static List<String> get_chipIds(List<DeviceModel> input) {
    List<String> names = [];
    for (var i in input){
      names.add(i.chipIp ?? "");
    }
    return names;
  }
}