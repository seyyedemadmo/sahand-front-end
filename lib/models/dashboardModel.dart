class CompanyDetail{
  String _all_company;
  String _active_company;

  CompanyDetail(this._active_company, this._all_company);

  String get allcompany => this._all_company;

  set allcompany(String value) => this._all_company = value;

  get activecompany => this._active_company;

  set activecompany( value) => this._active_company = value;
}


class DeviceDetail {
  String _all_device;
  String _active_device;
  String _non_send_device;
  String _deactive_device;

 String get all_device => this._all_device;

 set all_device(String value) => this._all_device = value;

 get active_device => this._active_device;

 set active_device( value) => this._active_device = value;

 get non_send_device => this._non_send_device;

 set non_send_device( value) => this._non_send_device = value;

 get deactive_device => this._deactive_device;

 set deactive_device( value) => this._deactive_device = value;

  DeviceDetail(this._all_device, this._active_device, this._non_send_device, this._deactive_device);
}


class UserDetailModel {
  String _active_user; 
  String _all_user; 
  String _band_user;
  String _session_active;

  get active_user => this._active_user;

 set active_user( value) => this._active_user = value;

 get all_user => this._all_user;

 set all_user( value) => this._all_user = value;

 get band_user => this._band_user;

 set band_user( value) => this._band_user = value;

  get session_active => this._session_active;

 set session_active( value) => this._session_active = value;

  UserDetailModel(this._active_user, this._all_user, this._band_user, this._session_active);


}