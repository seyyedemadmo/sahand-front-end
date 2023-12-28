import "package:Sahand/Screens/DataLive.dart";
import "package:Sahand/Screens/DeviceDataScreen.dart";
import "package:flutter/material.dart";
import "../Screens/ParameterScreen.dart";
import "../api/api_client.dart";
import '../Screens/DashboardScreen.dart';
import '../Screens/LoginScreen.dart';
import "../models/Users.dart";


class MyDrawer extends StatefulWidget {
  final APIClient _client;
  final String _selected;
  const MyDrawer(this._client, this._selected, {super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState(_selected, _client);
}

class _MyDrawerState extends State<MyDrawer> {
  final String _selected;
  final APIClient _client;
  String _username = "";
  String _last_login = "";
  var user;
  Color dashboard_color = Colors.transparent;
  Color parameter_color = Colors.transparent;
  Color date_live_color = Colors.transparent;
  Color show_device_color = Colors.transparent;
  Color version_control_color = Colors.transparent;
  Color devcice_manager_color = Colors.transparent;
  Color setting_color = Colors.transparent;

  _MyDrawerState(this._selected, this._client);

   @override
  void initState() {
    // TODO: implement initState
    if (_selected == "dashboard") dashboard_color = const Color.fromARGB(255, 250, 196, 0);
    else if (_selected == "parameter")  parameter_color =  const Color.fromARGB(255, 250, 196, 0);
    else if (_selected == "date_live") date_live_color = const Color.fromARGB(255, 250, 196, 0);
    else if (_selected == "show_device") show_device_color =  const Color.fromARGB(255, 250, 196, 0);
    else if (_selected == "version_control") version_control_color =  const Color.fromARGB(255, 250, 196, 0);
    else if (_selected == "device_manager") devcice_manager_color =  const Color.fromARGB(255, 250, 196, 0);
    else if (_selected == "setting") setting_color =  const Color.fromARGB(255, 250, 196, 0);
    user = User(_client);
    fetch_data();
    super.initState();
  }

  void fetch_data() async{
      int res =  await user.get_from_web();
      if (res == 200){
        setState(() {
          _username = user.username;
          _last_login = user.last_login;
        });
      }
      else if (res == 401){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Token expire"), backgroundColor: Colors.red,)
        );
        Future.delayed(const Duration(milliseconds: 2000), () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginPage()));
        });
      }
      else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("error from web: "+ res.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: const EdgeInsets.all(10),
          children: [
            const SizedBox(
              height: 15,
            ),
            DrawerHeader(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  image: const DecorationImage(
                    image: AssetImage("lib/assist/background.jpg"), 
                    fit: BoxFit.cover
                  ),
                ),
                child:  Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 60,
                          width: 60,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: const Icon(
                            Icons.person,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Builder(
                          builder: (BuildContext context) {
                            try{
                              if (user.username!= null){
                              return Text(
                                user.username,
                                style: const TextStyle(
                                  fontSize: 20, 
                                ), 
                              );
                            }
                            else{
                              return const Text(
                                "loading...",
                                style: TextStyle(
                                  fontSize: 20, 
                                ), 
                              );
                            }
                            }
                            catch (e) {
                              return const Text(
                                "loading...",
                                style: TextStyle(
                                  fontSize: 20, 
                                ), 
                              );
                            }
                          }
                        ),
                        Builder(
                        builder: (BuildContext context) {
                          try{
                            if (user.last_login!=null){
                            return Text(
                              "Last Login: " + user.last_login,
                              style: const TextStyle(
                                fontSize: 10, 
                              ), 
                            );
                          }
                          else{
                            return const Text(
                              "loading...",
                              style: TextStyle(
                                fontSize: 10, 
                              ), 
                            );
                          }
                          }
                          catch (e) {
                            return const Text(
                              "loading...",
                              style: TextStyle(
                                fontSize: 10, 
                              ), 
                            );
                          }
                        }
                        )
                      ]
                    )
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              height: 60,
              child: ElevatedButton.icon(
                onPressed: (){
                  if (_selected != "dashboard"){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardPage(_client)));
                  }
                  else{
                    Scaffold.of(context).closeDrawer();
                  }
                },
                icon: const Icon(
                  Icons.dashboard,
                ),
                label: const Text(
                  '\t\tDashboard',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                style:  ButtonStyle(
                  alignment: Alignment.centerLeft,
                  elevation: const MaterialStatePropertyAll(0),
                  backgroundColor: MaterialStatePropertyAll<Color>(dashboard_color),
                ),
              )
            ),
            SizedBox(
              height: 60,
              child: ElevatedButton.icon(
                onPressed: (){
                  if (_selected != "parameter"){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ParametersPage(_client)));
                  }
                  else{
                    Scaffold.of(context).closeDrawer();
                  }
                },
                icon: const Icon(
                  Icons.add_chart,
                ),
                label: const Text(
                  '\t\Parameters',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                style:  ButtonStyle(
                  alignment: Alignment.centerLeft,
                  elevation: const MaterialStatePropertyAll(0),
                  backgroundColor: MaterialStatePropertyAll<Color>(parameter_color),
                ),
              )
            ),
            SizedBox(
              height: 60,
              child: ElevatedButton.icon(
                onPressed: (){
                  if (_selected != "date_live"){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DeviceDataLiveScreen(_client)));
                  }
                  else{
                    Scaffold.of(context).closeDrawer();
                  }
                },
                icon: const Icon(
                  Icons.data_thresholding_outlined,
                ),
                label: const Text(
                  '\t\Data Live',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                style:  ButtonStyle(
                  alignment: Alignment.centerLeft,
                  elevation: const MaterialStatePropertyAll(0),
                  backgroundColor: MaterialStatePropertyAll<Color>(date_live_color),
                ),
              )
            ),
            SizedBox(
              height: 60,
              child: ElevatedButton.icon(
                onPressed: (){
                  if (_selected != "show_device"){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DateLiveScreen(_client)));
                  }
                  else{
                    Scaffold.of(context).closeDrawer();
                  }
                },
                icon: const Icon(
                  Icons.devices_rounded,
                ),
                label: const Text(
                  '\tShow Device Data',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                style:  ButtonStyle(
                  alignment: Alignment.centerLeft,
                  elevation: const MaterialStatePropertyAll(0),
                  backgroundColor: MaterialStatePropertyAll<Color>(show_device_color),
                ),
              )
            ),
            SizedBox(
              height: 60,
              child: ElevatedButton.icon(
                onPressed: (){
                },
                icon: const Icon(
                  Icons.commit_rounded,
                ),
                label: const Text(
                  '\t\tVersion Control',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                style:  ButtonStyle(
                  alignment: Alignment.centerLeft,
                  elevation: const MaterialStatePropertyAll(0),
                  backgroundColor: MaterialStatePropertyAll<Color>(version_control_color),
                ),
              )
            ),
            SizedBox(
              height: 60,
              child: ElevatedButton.icon(
                onPressed: (){
                },
                icon: const Icon(
                  Icons.precision_manufacturing_rounded,
                ),
                label: const Text(
                  '\t\tDevice manager',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                style:  ButtonStyle(
                  alignment: Alignment.centerLeft,
                  elevation: const MaterialStatePropertyAll(0),
                  backgroundColor: MaterialStatePropertyAll<Color>(version_control_color),
                ),
              )
            ),
            SizedBox(
              height: 60,
              child: ElevatedButton.icon(
                onPressed: (){
                },
                icon: const Icon(
                  Icons.settings,
                ),
                label: const Text(
                  '\t\tSetting',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                style:  ButtonStyle(
                  alignment: Alignment.centerLeft,
                  elevation: const MaterialStatePropertyAll(0),
                  backgroundColor: MaterialStatePropertyAll<Color>(version_control_color),
                ),
              )
            ),
          ],
        ),
      );
  }
}