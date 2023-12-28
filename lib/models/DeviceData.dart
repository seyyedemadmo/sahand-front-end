class DeviceDataModel {
  int? _id;
  String? _chipId;
  String? _receiveAt;
  Map<String, dynamic>? _data;
  int? _device;

  DeviceDataModel(
      {int? id, String? chipId, String? receiveAt, Map<String, dynamic>? data, int? device}) {
    if (id != null) {
      this._id = id;
    }
    if (chipId != null) {
      this._chipId = chipId;
    }
    if (receiveAt != null) {
      this._receiveAt = receiveAt;
    }
    if (data != null) {
      this._data = data;
    }
    if (device != null) {
      this._device = device;
    }
  }

  int? get id => _id;
  set id(int? id) => _id = id;
  String? get chipId => _chipId;
  set chipId(String? chipId) => _chipId = chipId;
  String? get receiveAt => _receiveAt;
  set receiveAt(String? receiveAt) => _receiveAt = receiveAt;
  Map<String, dynamic>? get data => _data;
  set data(Map<String, dynamic>? data) => _data = data;
  int? get device => _device;
  set device(int? device) => _device = device;

  DeviceDataModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _chipId = json['chip_id'];
    _receiveAt = json['receive_at'];
    _data = json['data'];
    _device = json['device'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['chip_id'] = this._chipId;
    data['receive_at'] = this._receiveAt;
    if (this._data != null) {
      data['data'] = this._data!;
    }
    data['device'] = this._device;
    return data;
  }
}

class FiledsModel {
  String? _chipIp;
  List<String>? _fields;

  FiledsModel({String? chipIp, List<String>? fields}) {
    if (chipIp != null) {
      this._chipIp = chipIp;
    }
    if (fields != null) {
      this._fields = fields;
    }
  }

  String? get chipIp => _chipIp;
  set chipIp(String? chipIp) => _chipIp = chipIp;
  List<String>? get fields => _fields;
  set fields(List<String>? fields) => _fields = fields;

  FiledsModel.fromJson(Map<String, dynamic> json) {
    _chipIp = json['chip_ip'];
    _fields = json['fields'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chip_ip'] = this._chipIp;
    data['fields'] = this._fields;
    return data;
  }
}
