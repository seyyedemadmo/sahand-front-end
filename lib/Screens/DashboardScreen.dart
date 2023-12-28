import "dart:convert";

import "package:flutter/material.dart";
import "package:http/http.dart";
import "../Screens/LoginScreen.dart";
import "../api/api_client.dart";
import "../components/AppBar.dart";
import "../components/Drawer.dart";
import '../models/dashboardModel.dart';

class DashboardPage extends StatefulWidget {
  final APIClient _client;

  const DashboardPage(this._client, {super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState(_client);
}

class _DashboardPageState extends State<DashboardPage> {
  var _company_detail;
  var _device_detail;
  var _user_detail;
  final APIClient _client;

  _DashboardPageState(this._client);

  @override
  void initState() {
    // TODO: implement initState
    fetch_data();
    super.initState();
  }


  void fetch_data() async{
    bool has_401 = false;

    Response response = await _client.c_get(Uri.parse("http://atibin.info:8585/api/main/company-detail/"));

    if (response.statusCode == 200){
        setState(() {
          _company_detail = CompanyDetail(
            jsonDecode(utf8.decode(response.bodyBytes))["active_company"].toString(),
          jsonDecode(utf8.decode(response.bodyBytes))["all_company"].toString()
        ); 
      });
    }
    else if (response.statusCode == 401){
       has_401 = true;
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("error from web: "+ response.statusCode.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }

    Response device_data = await _client.c_get(Uri.parse("http://atibin.info:8585/api/main/device/get_detail/"));

    if (device_data.statusCode == 200){
      var json = jsonDecode(utf8.decode(device_data.bodyBytes));
      setState(() {
        _device_detail = DeviceDetail(
        json["all_device"].toString(),
        json["active_device"].toString(),
        json["non_send_data"].toString(),
        json["deactivate_device"].toString(),
      );
      });
    }
    else if (device_data.statusCode == 401){
      has_401 = true;
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("error from web: "+ device_data.statusCode.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }


    Response user_detail = await _client.c_get(Uri.parse("http://atibin.info:8585/api/user/detail/"));
    if (user_detail.statusCode == 200){
      var ujson = jsonDecode(utf8.decode(user_detail.bodyBytes));
      setState(() {
        _user_detail = UserDetailModel(
          ujson["active_user"].toString(),
          ujson["all_user"].toString(),
          ujson["band_user"].toString(),
          ujson["session_active"].toString(),
        );
      });
    }
    else if (user_detail.statusCode == 401){
      has_401 = true;
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("error from web: "+ user_detail.statusCode.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }

    if (has_401){
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
    return Builder(
      builder: (context) => Scaffold(
        appBar: MyAppBar("Dashboard"),
        body: Column(children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Color.fromARGB(255, 231, 231, 231),
            ),
            height: 275,
            // width: 500,
            margin: const EdgeInsets.all(10),
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Device Summery",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Builder(
                  builder: (BuildContext context) {
                    try{
                      if (_device_detail.all_device!= null){
                      return Text(
                        _device_detail.all_device,
                        style: const TextStyle(
                          fontSize: 45,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }
                    else {
                      return const Text(
                        "loading...",
                        style: TextStyle(
                          fontSize: 45,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }
                    }
                    catch (e) {
                      return const Text(
                        "loading...",
                        style: TextStyle(
                          fontSize: 45,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }
                  } 
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "  Total Device",
                  style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Active device: ",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Builder(
                             builder: (BuildContext context) {
                              try {
                                if (_device_detail.active_device!= null){
                                return Text(
                                  _device_detail.active_device,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              }
                              else {
                                return const Text(
                                  "loading...",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              }
                              }
                              catch (e){
                                return const Text(
                                  "loading...",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              }
                            } 
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          )
                        ],
                      ),
                    )
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Deactive device: ",
                      style: TextStyle(fontSize: 14),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Builder(
                             builder: (BuildContext context) {
                              try{
                                if (_device_detail.deactive_device!= null){
                                return Text(
                                  _device_detail.deactive_device,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              }
                              else {
                                return const Text(
                                  "loading...",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              }
                            }
                            catch (e){
                              return const Text(
                                  "loading...",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                            }
                              
                            } 
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Icon(
                            Icons.cancel,
                            color: Color.fromARGB(255, 201, 9, 6),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Non-send data device: ",
                      style: TextStyle(fontSize: 14),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Builder(
                             builder: (BuildContext context) {
                              try {
                                if (_device_detail.active_device!= null){
                                return Text(
                                  _device_detail.active_device,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              }
                              else {
                                return const Text(
                                  "loading...",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              }
                              }
                              catch (e) {
                                return const Text(
                                  "loading...",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              }
                            } 
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Icon(
                            Icons.do_disturb_on,
                            color: Color.fromARGB(255, 255, 136, 0),
                          )
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Row(
            children: [
            Container(
              height: 200,
              width: (MediaQuery.of(context).size.width / 2) - 20,
              margin: const EdgeInsets.all(10),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 231, 231, 231),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Company Detail",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Builder(
                    builder: (BuildContext context) {
                      try{
                        if (_company_detail.allcompany != null){
                          return Text(
                            _company_detail.allcompany,
                            style: const TextStyle(
                              fontSize: 45,
                            ),
                          );
                        }
                        else {
                          // fetch_data();
                          return const Text(
                            "loading...",
                            style: TextStyle(
                              fontSize: 30,
                            ),
                          ); 
                        }
                      }
                      catch (e){
                        return const Text(
                            "loading...",
                            style: TextStyle(
                              fontSize: 30,
                            ),
                          );
                      }
                    }
                  ),
                  const Text(
                    "in total",
                    style: TextStyle(fontSize: 11),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 255, 255, 255),
                      elevation: 0,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.zero),
                      ),
                      side: const BorderSide(
                        width: 2,
                        color: Color.fromARGB(255, 255, 200, 3),
                      )
                    ),
                    child: const Text('View All'),
                  ),
                ],
              ),
            ),
            Container(
              height: 200,
              width: (MediaQuery.of(context).size.width / 2) - 20,
              margin: const EdgeInsets.all(10),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 231, 231, 231),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    "User Detail",
                    style: TextStyle(
                      fontSize: 12, 
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Builder(
                    builder: (BuildContext context){
                       try{
                        if (_user_detail.all_user != null){
                          return Text(
                            _user_detail.all_user,
                            style: const TextStyle(
                              fontSize: 45,
                            ),
                          );
                        }
                        else {
                          // fetch_data();
                          return const Text(
                            "loading...",
                            style: TextStyle(
                              fontSize: 30,
                            ),
                          ); 
                        }
                      }
                      catch (e){
                        return const Text(
                            "loading...",
                            style: TextStyle(
                              fontSize: 30,
                            ),
                          );
                      }
                    }, 
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Active User",
                        style: TextStyle(
                          fontSize: 11,
                        ),
                      ),
                      Builder(builder: (context) {
                        try{
                        if (_user_detail.active_user != null){
                          return Text(
                            _user_detail.active_user,
                            style: const TextStyle(
                              fontSize: 11,
                            ),
                          );
                        }
                        else {
                          // fetch_data();
                          return const Text(
                            "loading...",
                            style: TextStyle(
                              fontSize: 10,
                            ),
                          ); 
                        }
                      }
                      catch (e){
                        return const Text(
                            "loading...",
                            style: TextStyle(
                              fontSize: 10,
                            ),
                          );
                      }
                      })
                    ],
                    ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Band User",
                        style: TextStyle(
                          fontSize: 11,
                        ),
                      ),
                      Builder(builder: (context) {
                        try{
                        if (_user_detail.band_user != null){
                          return Text(
                            _user_detail.band_user,
                            style: const TextStyle(
                              fontSize: 11,
                            ),
                          );
                        }
                        else {
                          // fetch_data();
                          return const Text(
                            "loading...",
                            style: TextStyle(
                              fontSize: 10,
                            ),
                          ); 
                        }
                      }
                      catch (e){
                        return const Text(
                            "loading...",
                            style: TextStyle(
                              fontSize: 10,
                            ),
                          );
                      }
                      })
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Session Active",
                        style: TextStyle(
                          fontSize: 11,
                        ),
                      ),
                       Builder(builder: (context) {
                        try{
                        if (_user_detail.session_active != null){
                          return Text(
                            _user_detail.session_active,
                            style: const TextStyle(
                              fontSize: 11,
                            ),
                          );
                        }
                        else {
                          // fetch_data();
                          return const Text(
                            "loading...",
                            style: TextStyle(
                              fontSize: 10,
                            ),
                          ); 
                        }
                      }
                      catch (e){
                        return const Text(
                            "loading...",
                            style: TextStyle(
                              fontSize: 10,
                            ),
                          );
                      }
                      })
                    ],
                  ),

                ],
              ),
            )
          ],
          )
        ]),
        drawer: MyDrawer(_client, "dashboard"),
        drawerEnableOpenDragGesture: false,
      ),
    );
  }
}
