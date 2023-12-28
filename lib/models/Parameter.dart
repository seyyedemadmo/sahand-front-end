class ParameterModel {
  int? _id;
  String? _key;
  int? _address;
  int? _value;
  int? _device;

  ParameterModel(
      {int? id, String? key, int? address, int? value, int? device}) {
    if (id != null) {
      this._id = id;
    }
    if (key != null) {
      this._key = key;
    }
    if (address != null) {
      this._address = address;
    }
    if (value != null) {
      this._value = value;
    }
    if (device != null) {
      this._device = device;
    }
  }

  int? get id => _id;
  set id(int? id) => _id = id;
  String? get key => _key;
  set key(String? key) => _key = key;
  int? get address => _address;
  set address(int? address) => _address = address;
  int? get value => _value;
  set value(int? value) => _value = value;
  int? get device => _device;
  set device(int? device) => _device = device;

  ParameterModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _key = json['key'];
    _address = json['address'];
    _value = json['value'];
    _device = json['device'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['key'] = this._key;
    data['address'] = this._address;
    data['value'] = this._value;
    data['device'] = this._device;
    return data;
  }

  static List<ParameterModel> fromJsonArray(List<Map<String,dynamic>> array){
    List<ParameterModel> res = [];
    for (var i in array){
      res.add(ParameterModel.fromJson(i));
    }
    return res;
  }
}