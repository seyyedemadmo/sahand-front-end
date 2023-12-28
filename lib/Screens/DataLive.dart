import 'dart:convert';

import 'package:Sahand/Screens/LoginScreen.dart';
import 'package:Sahand/api/api_client.dart';
import 'package:Sahand/components/AppBar.dart';
import 'package:Sahand/components/Drawer.dart';
import 'package:Sahand/models/Device.dart';
import 'package:Sahand/models/DeviceData.dart';
import 'package:Sahand/models/Parameter.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart';
import "package:web_socket_channel/io.dart";

class DateLiveScreen extends StatefulWidget {
  APIClient _client;
  bool disable_chart = true;
  List<DeviceModel> devices = [];
  Map<String , List<int>> recieve_data = {};
  late DeviceModel selected_device;
  var fileds = null;
  var selectedField = null;
  DateLiveScreen(this._client, {super.key});

  @override
  State<DateLiveScreen> createState() => _DateLiveScreenState();
}

class _DateLiveScreenState extends State<DateLiveScreen> {
  String user_uuid = '';
  @override
  void initState() {
    // TODO: implement initState

    fetch_device(alarm: false);
    super.initState();
  }

  void fetch_device({bool alarm = true}) async{
    if (alarm) EasyLoading.show(status:"loading...", dismissOnTap: true);
    Response res = await widget._client.c_get(Uri.parse("http://atibin.info:8585/api/main/device/"));
    if (res.statusCode == 200){
      setState(() {
        widget.devices = DeviceModel.fromJsomArray(jsonDecode(utf8.decode(res.bodyBytes))["results"]);
      });
      if (alarm) EasyLoading.showSuccess("Successful");
    }
    else if (res.statusCode == 401){
      Future.delayed(const Duration(milliseconds: 2000), () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginPage()));
      });
      EasyLoading.showError("Expire Tocken");
    }
    else{
      if (alarm) EasyLoading.showError("Something goes wrong");
    }
  }

  void fetch_fields({bool alarm = false}) async{
    if (alarm) EasyLoading.show(status:"loading...", dismissOnTap: true);
    int device_id = widget.selected_device.id!;
    Response res = await widget._client.c_get(Uri.parse("http://atibin.info:8585/api/chart/$device_id/fields"));
    if (res.statusCode == 200){
      setState(() {
        widget.fileds = FiledsModel.fromJson(jsonDecode(utf8.decode(res.bodyBytes)));
      });
      if (alarm) EasyLoading.showSuccess("Successful");
    }
    else if (res.statusCode == 401){
      Future.delayed(const Duration(milliseconds: 2000), () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginPage()));
      });
      EasyLoading.showError("Expire Tocken");
    }
    else{
      if (alarm) EasyLoading.showError("Something goes wrong");
    }
  }
  void websocket_get_data(){
    if (widget.selectedField != null){

    }
  }
  void websocket_connect() async {
    Response user_res = await widget._client.c_get(Uri.parse("http://atibin.info:8585/api/user/self/retrieve/"));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar("Show Device Data"),
      drawer: MyDrawer(widget._client, "show_device"),
      body: 
        Column(
          children:[
            Container(
              height: 240,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(15),

              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "select your device:",
                    style: TextStyle(
                      fontSize: 20
                    ),
                  ),
                  const SizedBox( height: 15,),
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
                      widget.selected_device = device!;
                      fetch_fields(alarm: true);
                    },
                  ),
                  const SizedBox(height: 15,),
                  Builder(builder: (context) {
                    if (widget.fileds != null) {
                      return const Text(
                        "select field:",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      );
                    }
                    else{
                      return Container();
                    }
                  }),
                  const SizedBox(height: 15),
                  Builder(
                    builder:(context){
                      if (widget.fileds != null){
                        return DropdownSearch<String>(
                          autoValidateMode: AutovalidateMode.onUserInteraction,
                          items: widget.fileds.fields!,
                          filterFn: (String field, String filter){
                            if (field.contains(filter.trim()) || field.contains(filter.trim())){
                              return true;
                            }
                            return false;
                          },
                          popupProps:  PopupProps<String>.modalBottomSheet(
                            showSearchBox: true,
                            itemBuilder: fieldsItemBulder,
                            containerBuilder: fieldPopUpBuil,
                            title: const Text(
                              "Avaluble fields",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                              ),
                            emptyBuilder: fieldEmptyBuilder,
                            searchFieldProps: TextFieldProps(
                              autocorrect: true,
                              enableIMEPersonalizedLearning: true,
                              enableSuggestions: true,
                              autofillHints: Iterable.generate(widget.devices.length, (int index){return widget.devices[index].name!;} ),
                              enableInteractiveSelection: true,
                              decoration: InputDecoration(
                                labelText: "Search Box",
                                hintText: "fields name",
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
                          onChanged: (String? field){
                            setState(() {
                              widget.selectedField = field!;
                              widget.disable_chart = false;
                            });
                          },
                        );
                      }
                      else {
                        return Container();
                      }
                    }
                 ),
                ],
              ),
            ),
            Builder(
              builder: (context)  {
                if (widget.disable_chart){
                  return Container();
                }
                return Container(
                  height: 500,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: LineChart(
                    LineChartData(
                      borderData: FlBorderData(
                        border: Border.all(
                          width: 0.5
                        ),
                      ),
                      backgroundColor: Colors.transparent,
                      minY: -5,
                      maxY: 10,
                      minX: 0,
                      maxX: 8,
                      gridData: const FlGridData(
                        verticalInterval: 1
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          isStrokeCapRound: true,
                          barWidth: 2,
                          lineChartStepData: const LineChartStepData(stepDirection: LineChartStepData.stepDirectionForward),
                          spots: [
                            const FlSpot(0, 3),
                            const FlSpot(1, 4),
                            FlSpot(2, 2),
                            FlSpot(3, 5),
                            FlSpot(4, 2),
                            FlSpot(5, 3),
                            FlSpot(6, 4),
                            FlSpot(7, 6),
                            FlSpot(8, 4),
                        ],
                        isCurved: true,
                        shadow: const Shadow(color: Colors.amber),
                        color: Colors.amber.shade300
                      )
                    ]
                  ),
                  duration: const Duration(milliseconds: 500),
                      )
                );
              }
           )
          ] 
        )
    );
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

    Widget devicePopUpBuil(BuildContext context, Widget builded) {
    fetch_device(alarm: false);
    return Container(
      padding: EdgeInsets.all(15),
      child: builded
    );
  }

  Widget fieldsItemBulder(BuildContext context, String device, bool isSelected) {
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
                  Text(device),
                ]
              ),
              const Icon(Icons.device_hub)
            ],
          )
      )
    );
  }

  Widget fieldEmptyBuilder(BuildContext context , String filter){
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

  Widget fieldPopUpBuil(BuildContext context, Widget builded) {
    fetch_fields(alarm: false);
    return Container(
      padding: EdgeInsets.all(15),
      child: builded
    );
  }

}