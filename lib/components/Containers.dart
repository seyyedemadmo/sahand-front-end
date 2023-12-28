import "dart:convert";

import "package:dropdown_search/dropdown_search.dart";
import "package:flutter/material.dart";
import "package:http/http.dart";
import "../Screens/LoginScreen.dart";
import "../api/api_client.dart";
import "../models/Device.dart";

class DeviceSelectContainer extends StatefulWidget {
  final APIClient _client;
  const DeviceSelectContainer(this._client, {super.key});

  @override
  State<DeviceSelectContainer> createState() => _DeviceSelectContainerState();
}

class _DeviceSelectContainerState extends State<DeviceSelectContainer> {

  @override
  void initState() {
    // TODO: implement initState
    fetch_data();
    super.initState();
  }

  List<DeviceModel> devices = [];

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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Token expire"), backgroundColor: Colors.red,)
      );
      Future.delayed(const Duration(milliseconds: 2000), () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginPage()));
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
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
                 DropdownSearch<String>(
                    items: DeviceModel.get_full_name(devices),
                  )
              ],
            ),
          );
  }
}