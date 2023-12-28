import 'dart:async';
import 'dart:convert';

import 'package:Sahand/Screens/LoginScreen.dart';
import 'package:Sahand/api/api_client.dart';
import 'package:Sahand/components/AppBar.dart';
import 'package:Sahand/components/DataSourse.dart';
import 'package:Sahand/components/Drawer.dart';
import 'package:Sahand/models/Device.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart';

class DeviceDataLiveScreen extends StatefulWidget {
  APIClient _client;
  List<DeviceModel> devices = [];
  late var _selected_device = null;
  bool _botton_disable = true;
  late DataTableSource _device_data_sourse;
  DeviceDataLiveScreen(this._client, {super.key});

  @override
  State<DeviceDataLiveScreen> createState() => _DeviceDataLiveScreenState();
}

class _DeviceDataLiveScreenState extends State<DeviceDataLiveScreen> {

  Timer? timer;

  @override
  void initState() {
    fetch_data();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => check_new_data());
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer?.cancel();
  }

  void callback(){
    setState(() {
      fetch_data_without_alarm();
    });
  }

   void fetch_data_without_alarm() async{
    Response device_res = await widget._client.c_get(Uri.parse("http://atibin.info:8585/api/main/device/"));
    if (device_res.statusCode == 200){
      setState(() {
        widget.devices = DeviceModel.fromJsomArray(jsonDecode(utf8.decode(device_res.bodyBytes))["results"]);
      });
    }
    else if (device_res.statusCode == 401){
      Future.delayed(const Duration(milliseconds: 2000), () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginPage()));
      });
    }
    else{
    }
    if (widget._selected_device != null){
      int id = widget._selected_device.id!;
      Response parameter_res = await widget._client.c_get(Uri.parse("http://atibin.info:8585/api/main/device/$id/get_data/?limit=1000"));
      if (parameter_res.statusCode == 200){
        setState(() {
          var paramter_json = jsonDecode(utf8.decode(parameter_res.bodyBytes));
          widget._device_data_sourse = DeviceData(paramter_json["results"],widget._client, context, callback);
        });
      }
      else if (device_res.statusCode == 401){
        Future.delayed(const Duration(milliseconds: 2000), () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginPage()));
        });
        EasyLoading.showError("Expire Tocken");
      }
        widget._botton_disable = false;
    }
  }

  void fetch_data() async{
    Response device_res = await widget._client.c_get(Uri.parse("http://atibin.info:8585/api/main/device/"));
    if (device_res.statusCode == 200){
      setState(() {
        widget.devices = DeviceModel.fromJsomArray(jsonDecode(utf8.decode(device_res.bodyBytes))["results"]);
      });
    }
    else if (device_res.statusCode == 401){
      Future.delayed(const Duration(milliseconds: 2000), () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginPage()));
      });
    }
    else{
    }
    if (widget._selected_device != null){
      EasyLoading.show(status: "loading...", dismissOnTap: true);
      int id = widget._selected_device.id!;
      Response parameter_res = await widget._client.c_get(Uri.parse("http://atibin.info:8585/api/main/device/$id/get_data/?limit=1000"));
      if (parameter_res.statusCode == 200){
        setState(() {
          var paramter_json = jsonDecode(utf8.decode(parameter_res.bodyBytes));
          widget._device_data_sourse = DeviceData(paramter_json["results"],widget._client, context, callback);
        });
        EasyLoading.showSuccess("Successful");
      }
      else if (device_res.statusCode == 401){
        Future.delayed(const Duration(milliseconds: 2000), () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginPage()));
        });
        EasyLoading.showError("Expire Tocken");
      }
      else{
        EasyLoading.showError('something goes wrong');
      }
        widget._botton_disable = false;
    }
  }
  void check_new_data() async {
    print('test');
     if (widget._selected_device != null){
      int id = widget._selected_device.id!;
      Response parameter_res = await widget._client.c_get(Uri.parse("http://atibin.info:8585/api/main/device/$id/get_data/?limit=1000"));
      if (parameter_res.statusCode == 200){
        setState(() {
          var paramter_json = jsonDecode(utf8.decode(parameter_res.bodyBytes));
          widget._device_data_sourse = DeviceData(paramter_json["results"],widget._client, context, callback);
        });
      }
        widget._botton_disable = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) => Scaffold(
      appBar: const MyAppBar("Data Live"),
      drawer: MyDrawer(widget._client, "date_live"),
      drawerEnableOpenDragGesture: false,
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(15),
            height: 200,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 231, 231, 231),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Device",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 20,),
                DropdownSearch<DeviceModel>(
                  autoValidateMode: AutovalidateMode.onUserInteraction,
                  itemAsString: (DeviceModel device ) => device.name! ,
                  items: widget.devices,
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
                      autofillHints: Iterable.generate(widget.devices.length, (int index){return widget.devices[index].name!;} ),
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
                    widget._selected_device = device!;
                    fetch_data();
                  },
               ),
                const SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children:[
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber.shade300
                      ),
                      onPressed:  widget._botton_disable ? null : (){},
                      child: const Text("Show Data"),
                    )
                  ] 
                )
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height - 320,
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(15),
            decoration:  BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Builder(
              builder:(context){
                try {
                  return SingleChildScrollView(
                    padding: EdgeInsets.all(10),
                      child: PaginatedDataTable(
                        source: widget._device_data_sourse,
                        columns: const [
                          DataColumn(label: Text("Id")),
                          DataColumn(label: Text("Chip Id")),
                          DataColumn(label: Text("Receive at")),
                          DataColumn(label: Text("Data")),
                          DataColumn(label: Text("Device")),
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
        ]
      ),
    ));
  }
  Widget devicePopUpBuil(BuildContext context, Widget builded) {
    fetch_data_without_alarm();
    return Container(
      padding: const EdgeInsets.all(15),
      child: builded
    );
  }
}

Widget deviceitemBuilder(BuildContext context, DeviceModel device, bool isSelected) {
  return 
  InkWell(
    child: Container(
      margin: const EdgeInsets.all(15),
      height: 50,
      padding: const EdgeInsets.all(15),
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