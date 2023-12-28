import "dart:convert";

import "package:Sahand/components/DataSourse.dart";
import 'package:Sahand/components/Dialogs.dart';
import "package:dropdown_search/dropdown_search.dart";
import "package:flutter/material.dart";
import "package:flutter_easyloading/flutter_easyloading.dart";
import "package:http/http.dart";
import "LoginScreen.dart";
import "../api/api_client.dart";
import "../components/AppBar.dart";
import "../components/Containers.dart";
import "../components/Drawer.dart";
import "../models/Device.dart";

class ParametersPage extends StatefulWidget {
  final APIClient _client;
  bool enable_buttom = false;
  ParametersPage(this._client,{super.key});

  @override
  State<ParametersPage> createState() => _ParametersPageState(_client);
}

class _ParametersPageState extends State<ParametersPage> {
  final APIClient _client;
  List<DeviceModel> devices = [];
  late var _selected_device = null;
  bool _botton_disable = true;
  late DataTableSource _parameter_data_table_sourse;
  _ParametersPageState(this._client);

  @override
  void initState() {
    // TODO: implement initState
      fetch_data();
      super.initState();
    } 

  void callback(){
      setState(() {
        fetch_data();
      });
    }
    
  void search_callback(String filter){
      setState(() {
        EasyLoading.show(status: "loading ..." , dismissOnTap: true);
        search_api_parameter(filter);
        EasyLoading.showSuccess("Successful");
      });
    }

  void fetch_data_ithout_alarm() async{
    Response device_res = await widget._client.c_get(Uri.parse("http://atibin.info:8585/api/main/device/"));
    if (device_res.statusCode == 200){
      setState(() {
        devices = DeviceModel.fromJsomArray(jsonDecode(utf8.decode(device_res.bodyBytes))["results"]);
        print(devices.length);
        print(DeviceModel.get_names(devices));
      });
    }
    else if (device_res.statusCode == 401){
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text("Token expire"), backgroundColor: Colors.red,)
      // );
      Future.delayed(const Duration(milliseconds: 2000), () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginPage()));
      });
      EasyLoading.showError("Expire Tocken");
    }
    if (_selected_device != null && device_res.statusCode == 200){
      int id = _selected_device.id!;
      Response parameter_res = await widget._client.c_get(Uri.parse("http://atibin.info:8585/api/parameter/$id/device/"));
      if (parameter_res.statusCode == 200){
        setState(() {
          var paramter_json = jsonDecode(utf8.decode(parameter_res.bodyBytes));
          _parameter_data_table_sourse = ParameterData(paramter_json["results"],_client, context, callback);
        });
      } 
    }
    if (_selected_device != null){
        _botton_disable = false;
    }
  }

  void fetch_data() async{
    Response device_res = await widget._client.c_get(Uri.parse("http://atibin.info:8585/api/main/device/"));
    if (device_res.statusCode == 200){
      setState(() {
        devices = DeviceModel.fromJsomArray(jsonDecode(utf8.decode(device_res.bodyBytes))["results"]);
        print(devices.length);
        print(DeviceModel.get_names(devices));
      });
    }
    else if (device_res.statusCode == 401){
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text("Token expire"), backgroundColor: Colors.red,)
      // );
      Future.delayed(const Duration(milliseconds: 2000), () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginPage()));
      });
      EasyLoading.showError("Expire Tocken");
    }
    if (_selected_device != null && device_res.statusCode == 200){
      EasyLoading.show(status: "loading...", dismissOnTap: true);
      int id = _selected_device.id!;
      Response parameter_res = await widget._client.c_get(Uri.parse("http://atibin.info:8585/api/parameter/$id/device/"));
      if (parameter_res.statusCode == 200){
        setState(() {
          var paramter_json = jsonDecode(utf8.decode(parameter_res.bodyBytes));
          _parameter_data_table_sourse = ParameterData(paramter_json["results"],_client, context, callback);
        });
        EasyLoading.showSuccess("Successful");
      } 
    }
    if (_selected_device != null){
        _botton_disable = false;
    }
  }

  void search_api_parameter(String filter) async{
    if (_selected_device != null){
      int id = _selected_device.id!;
      Response parameter_res = await widget._client.c_get(Uri.http("atibin.info:8585","/api/parameter/$id/device/",{"search":filter}));
      if (parameter_res.statusCode == 200){
        setState(() {
          var paramter_json = jsonDecode(utf8.decode(parameter_res.bodyBytes));
          _parameter_data_table_sourse = ParameterData(paramter_json["results"],_client, context, callback);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Builder(
      builder: (context) => Scaffold(
      appBar: MyAppBar("Parameter"),
      body: Column(
        children: [
           Container(
            margin: EdgeInsets.all(10),
            height: 200 ,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 231, 231, 231),
              borderRadius: BorderRadius.circular(30),
            ),
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  "Device Paramer",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 20,),
                DropdownSearch<DeviceModel>(
                  autoValidateMode: AutovalidateMode.onUserInteraction,
                  itemAsString: (DeviceModel device ) => device.name! ,
                  items: devices,
                  filterFn: (DeviceModel device, String filter){
                    if (device.name!.contains(filter.trim()) || device.chipIp!.contains(filter.trim())){
                      return true;
                    }
                    return false;
                  },
                  popupProps:  PopupProps<DeviceModel>.modalBottomSheet(
                    showSearchBox: true,
                    itemBuilder: deviceitemBuilder,
                    containerBuilder: devicePopUpBuil,
                    title: const Text(
                      "Avaluble Device",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                      ),
                    emptyBuilder: deviceEmptyBuilder,
                    searchFieldProps: TextFieldProps(
                      autocorrect: true,
                      enableIMEPersonalizedLearning: true,
                      enableSuggestions: true,
                      autofillHints: Iterable.generate(devices.length, (int index){return devices[index].name!;} ),
                      enableInteractiveSelection: true,
                      decoration: InputDecoration(
                        labelText: "Search Box",
                        hintText: "Chip id or Name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                        )
                      )
                    )
                    
                  ),
                  dropdownButtonProps: const DropdownButtonProps(
                    color: Colors.black,
                    selectedIcon: Icon(Icons.arrow_drop_up_rounded)
                  ),
                  onChanged: (DeviceModel? device){
                    _selected_device = device!;
                    fetch_data();
                  },
               ),
                const SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: _botton_disable ? null : ()async{
                            // EasyLoading.show(status: "Loading...");
                            int device_id = _selected_device.id!;
                            Response res_device = await _client.c_get(Uri.parse("http://atibin.info:8585/api/parameter/$device_id/device/update_device_parameter/"));
                            Response res_head = await _client.c_get(Uri.parse("http://atibin.info:8585/api/parameter/$device_id/device/update_head_parameter/"));
                            setState(() {
                              fetch_data();
                            });
                            // EasyLoading.showSuccess("Successful");
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:  Color.fromARGB(255, 240, 200, 59),
                            elevation: 0
                          ),
                          child: const Text("Update"),
                        ),
                        const SizedBox(width: 7,),
                        ElevatedButton(
                          onPressed:  _botton_disable ? null :  (){
                            showDialog(context: context, builder: (context) => AddParameterDialog(_selected_device, _client, callback));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:  Colors.white,
                            elevation: 0
                          ),
                          child: const Text("add"),
                        ),
                      ]
                    ),
                    ElevatedButton(
                      onPressed:  _botton_disable ? null : (){
                        showDialog(context: context, builder: (context) => SearchParameterPanel(_selected_device, _client, search_callback));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:  Colors.white,
                        elevation: 0
                      ),
                      child: const Text("Search"),
                    ),
                  ],
                )
              ],
            ),
          ),
          Container(
            height:  MediaQuery.of(context).size.height - 320,
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 231, 231, 231),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Builder(
              builder:(context){
                try {
                  return SingleChildScrollView(
                    padding: EdgeInsets.all(10),
                      child: PaginatedDataTable(
                        source: _parameter_data_table_sourse,
                        columns: const [
                          DataColumn(label: Text("Key")),
                          DataColumn(label: Text("Value")),
                          DataColumn(label: Text("Device Id")),
                          DataColumn(label: Text("Address")),
                          DataColumn(label: Text("Options")),
                        ],
                        columnSpacing: 46,
                        horizontalMargin: 15,
                        dataRowHeight: 38,
                        )
                  );
                }
                catch (e){
                  return Container();
                }
              } 
            ),
          )
        ],
      ),
      drawer: MyDrawer(_client, "parameter"),
      drawerEnableOpenDragGesture: false,
    ));
  }

  Widget devicePopUpBuil(BuildContext context, Widget builded) {
    fetch_data_ithout_alarm();
    return Container(
      padding: EdgeInsets.all(15),
      child: builded
    );
  }
}

Widget deviceitemBuilder(BuildContext context, DeviceModel device, bool isSelected) {
  return 
  InkWell(
    child: Container(
      margin: EdgeInsets.all(15),
      height: 50,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.grey.shade200,
      ),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:[
                Text(device.name!),
                const SizedBox(width: 20),
                Text(device.chipIp!),
              ]
            ),
            const Icon(Icons.device_hub)
          ],
        )
    )
  );
}

Widget deviceEmptyBuilder(BuildContext context , String filter){
  return const SizedBox(
    height: 500,
    width: 500,
    child: Center(
      child: Text(
        "it's Empty",
        style: TextStyle(
          fontSize: 45,
          color: Colors.grey
        ),
      )
    )
  );
}