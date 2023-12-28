import "dart:convert";

import "package:Sahand/Screens/ParameterScreen.dart";
import "package:Sahand/api/api_client.dart";
import "package:Sahand/models/Device.dart";
import "package:Sahand/models/Parameter.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_easyloading/flutter_easyloading.dart";
import "package:http/http.dart";

class EditParameterPopUp extends StatelessWidget {
  final APIClient _client;
  final ParameterModel _target;
  final Function callback;
  TextEditingController key_field_controler = TextEditingController();
  TextEditingController address_field_controler = TextEditingController();
  TextEditingController value_field_controler = TextEditingController();
  EditParameterPopUp(this._target, this._client,this.callback, {super.key});

  @override
  Widget build(BuildContext context) {

    key_field_controler.text = _target.key!;
    address_field_controler.text = _target.address!.toString();
    value_field_controler.text = _target.value!.toString();

    return AlertDialog(
      title: const Text("Parameter Edit"),
      scrollable: true,
      content:Container(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            children:<Widget>[
              TextField(
                controller: key_field_controler,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  labelText: "Key",
                ),
              ),
              const SizedBox(height: 20,),
              TextField(
                controller: address_field_controler,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25)
                  ),
                  labelText: "Address",
                ),
              ),
              const SizedBox(height: 20,),
              TextField(
                controller: value_field_controler,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25)
                  ),
                  labelText: "Value",
                ),
              ),
              const SizedBox(height: 40,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                 Container(
                  width: 130,
                   child: ElevatedButton(
                     onPressed: (){Navigator.of(context, rootNavigator: true).pop('dialog');},
                     child: const Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Icon(Icons.cancel),
                         Text(
                          "Cancel",
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          ),
                          ),
                       ],
                     ),
                   ),
                 ),
                 Container(
                  width: 130,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:  Color.fromARGB(255, 243, 210, 92),
                      ),
                      onPressed: () async {
                        EasyLoading.show(
                          status: "loading...",
                          dismissOnTap: true
                        );
                        try{
                          Map<String, dynamic> send_adta = {
                            "key": key_field_controler.text,
                            "address":  int.parse(address_field_controler.text),
                            "value": int.parse(value_field_controler.text),
                            "device": _target.device
                          };
                          int device_id = _target.device!;
                          int parameter_id = _target.id!;
                          Response res = await _client.c_put(Uri.parse("http://atibin.info:8585/api/parameter/$device_id/device/$parameter_id/"), send_adta);
                          if (res.statusCode == 200){
                            EasyLoading.showSuccess("Update Success");
                          }
                          else if (res.statusCode == 401){
                            EasyLoading.showError("token expire: " +  jsonDecode(utf8.decode(res.bodyBytes))["detail"].toString());
                          }
                          else{
                            EasyLoading.showError("fail to update: " + jsonDecode(utf8.decode(res.bodyBytes)));
                          }
                        }
                        catch (e){
                          print(e.toString());
                          EasyLoading.showError("Error in device: " + e.toString());
                        }
                        finally{
                          callback();
                          Navigator.of(context, rootNavigator: true).pop('dialog');
                        }
                          
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.check_circle),
                          Text(
                            "Submit",
                            style: TextStyle(
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
      )
    );
  }
}

class DeleteParameterDialog extends StatefulWidget {
  final APIClient _client;
  final ParameterModel _target;
  final Function callback;
  const DeleteParameterDialog(this._client, this._target, this.callback, {super.key});

  @override
  State<DeleteParameterDialog> createState() => _DeleteParameterDialogState();
}

class _DeleteParameterDialogState extends State<DeleteParameterDialog> {

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Delete Parameter", 
        style: TextStyle(
          fontWeight: FontWeight.bold
        ),
      ),
      content: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children:<Widget>[
              const Text(
                "are you sure to delete this item?",
                style: TextStyle(
                  fontSize: 16
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                 Container(
                  width: 130,
                   child: ElevatedButton(
                     onPressed: (){Navigator.of(context, rootNavigator: true).pop('dialog');},
                     child: const Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Icon(Icons.cancel),
                         Text(
                          "No",
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          ),
                          ),
                       ],
                     ),
                   ),
                 ),
                 Container(
                  width: 130,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:  Color.fromARGB(255, 243, 210, 92),
                      ),
                      onPressed: () async {
                        EasyLoading.show(status: "loading...", dismissOnTap: true);
                        try{
                          int device_id = widget._target.device!;
                          int parameter_id = widget._target.id!;
                          Response res = await widget._client.c_delete(Uri.parse("http://atibin.info:8585/api/parameter/$device_id/device/$parameter_id/"));
                          if (res.statusCode == 204){
                            EasyLoading.showSuccess("remove parameter successful");
                          }
                          else if (res.statusCode == 401){
                            EasyLoading.showError("Token expire");
                          }
                          else {
                            EasyLoading.showError("we have some error");
                          }
                        }
                        catch (e){
                          EasyLoading.showError("we have some error");
                        }
                        finally{
                          widget.callback();
                          Navigator.of(context, rootNavigator: true).pop('dialog');
                        }
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.check_circle),
                          Text(
                            "Yes",
                            style: TextStyle(
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
      ),
    );
  }
}

class AddParameterDialog extends StatelessWidget {
  TextEditingController _key_field_controler = TextEditingController();
  TextEditingController _value_field_controler = TextEditingController();
  TextEditingController _address_field_controler = TextEditingController();
  APIClient _client;
  DeviceModel _target;
  Function callback;
  AddParameterDialog(this._target,this._client, this.callback, {super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add Parameter"),
      content: Container(
        height: 280,
        child: Column(
          children: [
            TextField(
                controller: _key_field_controler,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  labelText: "Key",
                  hintText: "Name of parameter"
                ),
              ),
              const SizedBox(height: 10,),
              TextField(
                controller: _value_field_controler,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  labelText: "Address",
                  hintText: "Memory Address"
                ),
              ),
              const SizedBox(height: 10,),
              TextField(
                controller: _address_field_controler,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  labelText: "Value",
                  hintText: "Parameter value"
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: (){
                      Navigator.of(context, rootNavigator: true).pop('dialog');
                    }, 
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white
                    ),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                      ),
                    )
                  ),
                  ElevatedButton(
                    onPressed: () async{
                       EasyLoading.show(status: "loading...", dismissOnTap: true);
                        try{
                          Map<String, dynamic> send_adta = {
                            "key": _key_field_controler.text,
                            "address":  int.parse(_address_field_controler.text),
                            "value": int.parse(_value_field_controler.text),
                            "device": _target.id
                          };
                          int device_id = _target.id!;
                          int parameter_id = _target.id!;
                          Response res = await _client.c_post(Uri.parse("http://atibin.info:8585/api/parameter/$device_id/device/"), send_adta);
                          if (res.statusCode == 201){
                            EasyLoading.showSuccess("create Success");
                          }
                          else if (res.statusCode == 401){
                            EasyLoading.showError("token expire: " +  jsonDecode(utf8.decode(res.bodyBytes))["detail"].toString());
                          }
                          else{
                            EasyLoading.showError("fail to create: " + jsonDecode(utf8.decode(res.bodyBytes)));
                          }
                        }
                        catch (e){
                          print(e.toString());
                          EasyLoading.showError("Error in device: " + e.toString());
                        }
                        finally{
                          callback();
                          Navigator.of(context, rootNavigator: true).pop('dialog');
                        }

                    }, 
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber.shade300
                    ),
                    child: const Text(
                      "Submit",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                      ),
                    )
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}


class SearchParameterPanel extends StatelessWidget {
  APIClient _client;
  DeviceModel _target;
  Function callback;
  TextEditingController _search_field_controller = TextEditingController();
  SearchParameterPanel(this._target, this._client, this.callback, {super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Search parameter"),
      content: Container(
        height: 150,
        child: Column(
          children: [
            TextField(
                controller: _search_field_controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  labelText: "Search",
                  hintText: "Like P50 .. "
                ),
              ),
              const SizedBox(height: 35,),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: (){
                    // EasyLoading.show(status: "Loaing...");
                    callback(_search_field_controller.text);
                    // EasyLoading.showSuccess("successfull");
                    Navigator.of(context, rootNavigator: true).pop('dialog');
                  }, 
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber.shade300
                  ),
                  child: const Text(
                    "Search",
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                )
              )
          ],
        ),
      ),
    );
  }
}